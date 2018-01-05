//
//  NewHomeBannerVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/7/26.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NewHomeBannerVC.h"
#import "CustomTopBtn.h"
#import "ProductListVC.h"
#import "EditUserInfoVC.h"
#import "CustomerInfo.h"
#import "OrderNumTool.h"
#import "HYBLoopScrollView.h"
#import "CusHauteCoutureView.h"
#import "NewCustomizationVC.h"
#import "NakedDriLibViewController.h"
@interface NewHomeBannerVC ()<UINavigationControllerDelegate>
@property (nonatomic,  weak)UIView *baView;
@property (nonatomic,  weak)UIWindow *keyWin;
@property (nonatomic,strong)NSArray *photos;
@property (nonatomic,strong)NSArray *bPhotos;
@property (nonatomic,  weak)UIView *proDriView;
@property (nonatomic,  weak)HYBLoopScrollView *loopView;
@property (nonatomic,strong)CusHauteCoutureView *cusView;
@end

@implementation NewHomeBannerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNewHomeData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self creatBottomBtn];
    [self loadNSNotification];
    [self loadAddressDataInfo];
}
//添加通知
- (void)loadNSNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:)
             name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)orientChange:(NSNotification *)notification{
    BOOL isDev = SDevWidth>SDevHeight;
    if (isDev) {
        [self setLoopScrollView:self.photos];
    }else{
        [self setLoopScrollView:self.bPhotos];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
//    [self resetWindow];
}
//加载默认地址
- (void)loadAddressDataInfo{
    NSString *url = [NSString stringWithFormat:@"%@InitDataForQxzx",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            StorageDataTool *data = [StorageDataTool shared];
            data.isMain = [response.data[@"IsMasterAccount"]boolValue];
            if ([YQObjectBool boolForObject:response.data[@"address"]]){
                data.addInfo = [AddressInfo mj_objectWithKeyValues:response.data[@"address"]];
            }
            if ([YQObjectBool boolForObject:response.data[@"DefaultCustomer"]]){
                data.cusInfo = [CustomerInfo mj_objectWithKeyValues:response.data[@"DefaultCustomer"]];
            }
        }
    } requestURL:url params:params];
}
//重置视图
- (void)resetWindow{
    if (self.keyWin) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.cusView removeFromSuperview];
            self.keyWin.windowLevel = 200;
            self.keyWin.hidden = YES;
            self.keyWin = nil;
            self.cusView = nil;
        }];
    }
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)loadNewHomeData{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@IndexPageForQxzx",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"horizontal"]]) {
                self.photos = response.data[@"horizontal"];
            }
            if ([YQObjectBool boolForObject:response.data[@"vertical"]]) {
                self.bPhotos = response.data[@"vertical"];
            }
            BOOL isDev = SDevWidth>SDevHeight;
            if (isDev) {
                [self setLoopScrollView:self.photos];
            }else{
                [self setLoopScrollView:self.bPhotos];
            }
        }
    } requestURL:url params:params];
}

- (void)setLoopScrollView:(NSArray *)arr{
    if (self.loopView) {
        [self.loopView removeFromSuperview];
        self.loopView = nil;
    }
    HYBLoopScrollView *loop = [HYBLoopScrollView loopScrollViewWithFrame:
                               CGRectMake(0, 0, SDevWidth, SDevHeight) imageUrls:arr];
    loop.timeInterval = 6.0;
    loop.didSelectItemBlock = ^(NSInteger atIndex,HYBLoadImageView  *sender){
        
    };
    loop.alignment = kPageControlAlignRight;
    [self.view addSubview:loop];
    [self.view sendSubviewToBack:loop];
    self.loopView = loop;
}

- (void)creatBottomBtn{
    CGFloat width = MIN(SDevWidth,SDevHeight)*0.9;
    UIView *bottomV = [UIView new];
    [self.view addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(width, 80));
    }];
    NSArray *arr = @[@"p_11-1",@"p_03-1",@"p_04-1",@"p_06-1",@"p_08-1"];
    NSArray *arrS = @[@"快速定制",@"产品",@"个性定制",@"裸钻库",@"个人中心"];
    CGFloat mar = (width-arr.count*60)/(arr.count-1);
    for (int i=0; i<arr.count; i++) {
        CustomTopBtn *right = [CustomTopBtn creatCustomView];
        right.bBtn.tag = i;
        [right.sBtn setBackgroundImage:[UIImage imageNamed:arr[i]] forState:
                                   UIControlStateNormal];
        right.titleLab.text = arrS[i];
        [right.bBtn addTarget:self action:@selector(openClick:)
                                  forControlEvents:UIControlEventTouchUpInside];
        right.frame = CGRectMake(i*(60+mar), 0, 60, 80);
        [bottomV addSubview:right];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.baView.hidden==NO) {
        self.baView.hidden = YES;
    }
}

- (void)openClick:(UIView *)btn{
    if (btn.tag==0) {
        if ([[AccountTool account].isNorm intValue]==1) {
            [MBProgressHUD showSuccess:@"高级定制不能定制"];
            return;
        }
        if ([[AccountTool account].isNoShow intValue]==1||
            [[AccountTool account].isNoDriShow intValue]==1) {
            [MBProgressHUD showSuccess:@"不显示价格不能定制"];
            return;
        }
        if (self.cusView) {
            [self resetWindow];
        }else{
            [self openWindowCusHuateView];
        }
    }else if(btn.tag==1){
        [self resetWindow];
        ProductListVC *list = [ProductListVC new];
        [self.navigationController pushViewController:list animated:YES];
    }else if(btn.tag==2){
        [self resetWindow];
        NewCustomizationVC *cusVc = [NewCustomizationVC new];
        [self.navigationController pushViewController:cusVc animated:YES];
    }else if(btn.tag==3){
        [self resetWindow];
        NakedDriLibViewController *list = [NakedDriLibViewController new];
        [self.navigationController pushViewController:list animated:YES];
    }else{
        [self resetWindow];
        EditUserInfoVC *list = [EditUserInfoVC new];
        [self.navigationController pushViewController:list animated:YES];
    }
}

- (void)openWindowCusHuateView{
    CGFloat wid = MIN(SDevWidth, SDevHeight);
    CGFloat height = 320;
    if (wid>320) {
        height = 340;
    }
    if (!IsPhone) {
        height = 400;
    }
    if (self.cusView) {
        return;
    }
    CusHauteCoutureView *aView = [[CusHauteCoutureView alloc] initWithFrame:CGRectZero];
    aView.driBack = ^(int staue,BOOL isYes){
        if (staue==0) {
            if (isYes) {
                [UIView animateWithDuration:0.5 animations:^{
                    [self.cusView mas_updateConstraints:^(MASConstraintMaker *make) {
                          make.width.mas_equalTo(@22);
                    }];
                    [self.cusView layoutIfNeeded];//强制绘制
                }];
            }else{
                [UIView animateWithDuration:0.5 animations:^{
                    [self.cusView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(height-30);
                    }];
                    [self.cusView layoutIfNeeded];//强制绘制
                }];
            }
        }else{
            [self resetWindow];
        }
    };
    // 当前顶层窗口
    UIWindow *window = [OrderNumTool lastWindow];
    window.frame = CGRectMake(0, 0, SDevWidth, SDevHeight);
    window.backgroundColor = [UIColor clearColor];
    // 添加到窗口
    [window addSubview:aView];
    [UIView animateWithDuration:0.5 animations:^{
        [aView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(window).offset(0);
            make.centerY.mas_equalTo(window.mas_centerY);
            make.width.mas_equalTo(height-30);
            make.height.mas_equalTo(height);
        }];
        [window layoutIfNeeded];//强制绘制
    }];
    self.cusView = aView;
    self.keyWin = window;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
