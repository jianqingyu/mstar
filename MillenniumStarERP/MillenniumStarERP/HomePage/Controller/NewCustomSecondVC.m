//
//  NewCustomSecondVC.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/5/16.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "NewCustomSecondVC.h"
#import "NewPerCustomizeView.h"
#import "NewCustomVerticalView.h"
#import "HYBLoopScrollView.h"
#import "NewCustomizationInfo.h"
#import "StrWithIntTool.h"
#import "CustomPickView.h"
#import "OrderListInfo.h"
#import "NewCustomizationSureVC.h"
#import "NewCustomizationHeadInfo.h"
#import "NakedDriLibViewController.h"
#import "CustomJewelInfo.h"
#import "NewCustomPublicInfo.h"
@interface NewCustomSecondVC ()<UINavigationControllerDelegate>
@property (nonatomic,strong)NSMutableDictionary *mutDic;
@property (nonatomic,strong)NewCustomVerticalView *verView;
@property (nonatomic,strong)NewPerCustomizeView *croView;
@property (nonatomic,assign)int index;
@end

@implementation NewCustomSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createVerAndCrossView];
    [self changeVerOrCrossView];
    [self loadHomeData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeNakedDri:)
                                                name:NotificationDriName object:nil];
}
// 横竖屏页面
- (void)createVerAndCrossView{
    NewCustomVerticalView *ver = [NewCustomVerticalView new];
    ver.back = ^(id model) {
        [self loadNextController:model];
    };
    self.verView = ver;
    NewPerCustomizeView *cro = [NewPerCustomizeView new];
    cro.back = ^(id model) {
        [self loadNextController:model];
    };
    self.croView = cro;
}
//修改裸石
- (void)changeNakedDri:(NSNotification *)notification{
    NakedDriSeaListInfo *listInfo = notification.userInfo[UserInfoDriName];
    NSArray *infoArr = @[@"钻石",listInfo.Weight,listInfo.Shape,listInfo.Color,
                         listInfo.Purity,listInfo.CertCode];
    NSDictionary *notiDic = @{@"driArr":infoArr,@"infoId":listInfo.id,
                              @"price":listInfo.Price};
    if (SDevHeight>SDevWidth) {
        [self.verView setupDriInfo:notiDic];
    }else{
        [self.croView setupDriInfo:notiDic];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)orientChange:(NSNotification *)notification{
    [self changeVerOrCrossView];
}
#pragma mark -- 网络请求
- (void)loadHomeData{
    NewCustomPublicInfo *puInfo = [NewCustomPublicInfo shared];
    puInfo.netData = @{@"isEd":@(self.isEd),@"porId":@(self.proId)};
    [puInfo loadHomeData:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (SDevHeight>SDevWidth) {
                [self.verView setupData];
            }else{
                [self.croView setupData];
            }
        });
    }];
}
#pragma mark - 横竖屏切换
- (void)changeVerOrCrossView{
    [self.croView removeFromSuperview];
    [self.verView removeFromSuperview];
    BOOL isVertical = SDevHeight>SDevWidth;
    if (isVertical) {
        [self.view addSubview:self.verView];
        [self.verView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
            make.left.equalTo(self.view).offset(0);
            make.right.equalTo(self.view).offset(0);
            make.bottom.equalTo(self.view).offset(0);
        }];
    }else{
        [self.view addSubview:self.croView];
        [self.croView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
            make.left.equalTo(self.view).offset(0);
            make.right.equalTo(self.view).offset(0);
            make.bottom.equalTo(self.view).offset(0);
        }];
    }
    NewCustomPublicInfo *info = [NewCustomPublicInfo shared];
    if (SDevHeight>SDevWidth) {
        if (info.baseArr.count>0) {
            [self.verView setupData];
        }
    }else{
        if (info.baseArr.count>0) {
            [self.croView setupData];
        }
    }
}

- (void)loadNextController:(id)model{
    if (self.isEd) {
        [self loadEditType:model];
        return;
    }
    NewCustomizationSureVC *sureVc = [NewCustomizationSureVC new];
    [self.navigationController pushViewController:sureVc animated:YES];
}

- (void)loadEditType:(NSDictionary *)data{
    OrderListInfo *listI = [OrderListInfo mj_objectWithKeyValues:data];
    if (self.back) {
        self.back(listI);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
