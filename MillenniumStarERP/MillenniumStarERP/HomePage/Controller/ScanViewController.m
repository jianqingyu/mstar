//
//  ScanViewController.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/9.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ScanViewController.h"
#import "PureLayout.h"
@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,
                              UIAlertViewDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    [self setupBaseView];
    [self setupCamera];
}
#pragma mark -- 设置扫描背景
- (void)setupBaseView{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"没有相机权限" message:@"请去设置-隐私-相机中对订单系统授权" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:okAction];
        
        hasCameraRight = NO;
        return;
    }
    hasCameraRight = YES;

    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.image = [UIImage imageNamed:@"contact_scanframe"];
    [self.view addSubview:imageView];
    [imageView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:100];
    [imageView autoSetDimensionsToSize:CGSizeMake(200, 200)];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 30)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.text = @"将取景框对准二维码";
    [self.view addSubview:labIntroudction];
    [labIntroudction autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:imageView];
    [labIntroudction autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:imageView];
    [labIntroudction autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:imageView withOffset:8];
    
    upOrdown = NO;
    num = 0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 110, 220, 2)];
    _line.image = [UIImage imageNamed:@"line_icon"];
    [self.view addSubview:_line];
    [_line autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:imageView withOffset:40];
    [_line autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:imageView withOffset:-40];
    [_line autoSetDimension:ALDimensionHeight toSize:2];
    [_line autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:imageView withOffset:10];
}

- (void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(CGRectGetMinX(_line.frame), 110+2*num, CGRectGetWidth(_line.frame), CGRectGetHeight(_line.frame));
        if (2 * num == CGRectGetHeight(imageView.frame) - 20) {
            upOrdown = YES;
        }
    }else{
        num --;
        _line.frame = CGRectMake(CGRectGetMinX(_line.frame), 110+2*num, CGRectGetWidth(_line.frame), CGRectGetHeight(_line.frame));
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

- (BOOL)navigationShouldPopOnBackButton
{
    [timer invalidate];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (hasCameraRight) {
        if (_session && ![_session isRunning]) {
            [_session startRunning];
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
}
#pragma mark -- 扫描
- (void)setupCamera
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        // Device
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        // Input
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        // Output
        _output = [[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        // Session
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:self.input])
        {
            [_session addInput:self.input];
        }
        
        if ([_session canAddOutput:self.output])
        {
            [_session addOutput:self.output];
        }
        // 条码类型 AVMetadataObjectTypeQRCode
        CGRect inFrame = CGRectMake(164/SDevHeight,(SDevWidth-200)*0.5/SDevWidth,200/SDevHeight,200/SDevWidth);
        _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        [_output setRectOfInterest:inFrame];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面 Preview
            _preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
            _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
//            _preview.frame = CGRectMake(20,110,280,280);
            _preview.frame = self.view.bounds;
            [self.view.layer insertSublayer:self.preview atIndex:0];
            // Start
            [_session startRunning];
        });
    });
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        [_session stopRunning];
        [timer invalidate];
        if (stringValue.length > 0) {
            if (self.scanBack) {
                self.scanBack(stringValue);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
