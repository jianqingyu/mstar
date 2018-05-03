//
//  ScanViewController.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/9.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ScanViewController.h"
#import "PureLayout.h"
#import "CustomTitleView.h"
#import "CustomTextField.h"
#import "KeyBoardView.h"
#import "QuickScanOrderVC.h"
#import "IQKeyboardManager.h"
@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,
                              UINavigationControllerDelegate,
UIImagePickerControllerDelegate,UITextFieldDelegate,
KeyBoardViewDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;
@property (weak,   nonatomic) UITextField *searchFie;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSearchBar];
    [self setupBaseView];
//    [self creatNaviBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:)
                 name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (hasCameraRight) {
        if (_session && ![_session isRunning]) {
            [_session startRunning];
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self
                                               selector:@selector(animation1) userInfo:nil repeats:YES];
    }
     [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)setupSearchBar{
    CGFloat width = SDevWidth*0.7;
    CustomTitleView *titleView= [[CustomTitleView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    [titleView setLayerWithW:5 andColor:BordColor andBackW:0.5];
    titleView.backgroundColor = [UIColor clearColor];
    
    CustomTextField *titleFie = [[CustomTextField alloc]initWithFrame:CGRectZero];
    [titleView addSubview:titleFie];
    titleFie.borderStyle = UITextBorderStyleNone;
    titleFie.keyboardType = UIKeyboardTypeASCIICapable;
    [titleFie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView).offset(5);
        make.top.equalTo(titleView).offset(0);
        make.right.equalTo(titleView).offset(-35);
        make.height.mas_equalTo(@30);
    }];
    titleFie.delegate = self;
    
    UIButton *seaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [seaBtn addTarget:self action:@selector(btnClick) forControlEvents:
     UIControlEventTouchUpInside];
    [seaBtn setImage:[UIImage imageNamed:@"icon_search"] forState:
     UIControlStateNormal];
    [titleView addSubview:seaBtn];
    [seaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView).offset(0);
        make.left.equalTo(titleFie.mas_right).with.offset(0);
        make.right.equalTo(titleView).offset(0);
        make.height.mas_equalTo(@30);
    }];
    _searchFie = titleFie;
    [self setSearchFieKeyBoard];
    
    self.navigationItem.titleView = titleView;
}

- (void)setSearchFieKeyBoard{
    self.searchFie.inputView = nil;
    KeyBoardView * KBView = [[KeyBoardView alloc]init];
    KBView.delegate = self;
    self.searchFie.inputView = KBView;
    KBView.inputSource = self.searchFie;
}

- (void)btnClick:(KeyBoardView *)headView andIndex:(NSInteger)index{
    if (index==201) {
        self.searchFie.inputView = nil;
        [self.searchFie reloadInputViews];
    }else{
        [self.searchFie resignFirstResponder];
        [self searchClick];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField selectAll:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self setSearchFieKeyBoard];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchClick];
    return YES;
}

- (void)btnClick{
    [self searchClick];
}

- (void)searchClick{
    [self.searchFie resignFirstResponder];
    if (self.scanBack) {
        self.scanBack(self.searchFie.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)orientChange:(NSNotification *)notification{
    _preview.frame = self.view.bounds;
    [self.searchFie resignFirstResponder];
}

//- (void)creatNaviBtn{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"相册"
//                     style:UIBarButtonItemStyleDone target:self action:@selector(choicePhoto)];
//}
#pragma mark -- 设置扫描背景
- (void)setupBaseView{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [NewUIAlertTool show:@"请去设置-隐私-相机中对订单系统授权" okBack:nil andView:self.view yes:NO];
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
    [self setupCamera];
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
        CGRect inFrame = CGRectMake((100+64)/SDevHeight,(SDevWidth-200)*0.5/SDevWidth,200/SDevHeight,200/SDevWidth);
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
//#pragma mark --调用相册扫描--
//- (void)choicePhoto{
//    //调用相册
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
//    //UIImagePickerControllerSourceTypePhotoLibrary为相册
//    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//
//    //设置代理UIImagePickerControllerDelegate和UINavigationControllerDelegate
//    imagePicker.delegate = self;
//
//    [self presentViewController:imagePicker animated:YES completion:nil];
//}
////选中图片的回调
//- (void)imagePickerController:(UIImagePickerController*)picker
//didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    //取出选中的图片
//    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
//    NSData *imageData = UIImagePNGRepresentation(pickImage);
//    CIImage *ciImage = [CIImage imageWithData:imageData];
//
//    //创建探测器
//    //CIDetectorTypeQRCode表示二维码，这里选择CIDetectorAccuracyLow识别速度快
//    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil
//                                  options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
//    NSArray *feature = [detector featuresInImage:ciImage];
//
//    //取出探测到的数据
//    for (CIQRCodeFeature *result in feature) {
//        NSString *content = result.messageString;// 这个就是我们想要的值
//        if (content.length > 0) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//            if (self.scanBack) {
//                self.scanBack(content);
//            }
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
//}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
