//
//  NakedDriListOrderVc.m
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriListOrderVc.h"
#import "UserManagerMenuHrizontal.h"
#import "UserManagerScrollPageView.h"
#import "SearchOrderVc.h"
#define MENUHEIHT 40
@interface NakedDriListOrderVc ()<UserManagerMenuHrizontalDelegate,UserManagerScrollPageViewDelegate>{
    NSArray*titleArray;
    UserManagerScrollPageView*mScrollPageView;
    UserManagerMenuHrizontal*menuHorizontalView;
}

@end

@implementation NakedDriListOrderVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"裸钻库所有订单";
    titleArray = @[@{@"title":@"待付款",@"netUrl":@"stoneWaitPayOrderList",@"proId":@"10"},
                   @{@"title":@"已付款",@"netUrl":@"stoneAlreadyPayOrderList",@"proId":@"20"},
                   @{@"title":@"已发货",@"netUrl":@"stoneAlreadyDeliverGoodsOrderList",
                     @"proId":@"30"},
                   @{@"title":@"已完成",@"netUrl":@"stoneAlreadyFinishOrderList",
                     @"proId":@"40"}];
    [self initCustomView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_return"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
}

- (void)back{
    BaseViewController *baseVc = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:baseVc animated:YES];
}

- (void)orientChange:(NSNotification *)notification{
    [mScrollPageView moveScrollowViewToFirst];
}
#pragma mark UI初始化
- (void)initCustomView{
    //main view
    UIView *mainContentView = [[UIView alloc] init];
    menuHorizontalView = [[UserManagerMenuHrizontal alloc] initWithFrame:CGRectZero ButtonItems:titleArray];
    menuHorizontalView.delegate = self;
    [mainContentView addSubview:menuHorizontalView];
    
    //初始化滑动列表
    mScrollPageView = [[UserManagerScrollPageView alloc] initScrollPageView:CGRectZero
                                                                 navigation:self.navigationController];
    mScrollPageView.delegate = self;
    [mScrollPageView setContentOfTables:titleArray andId:@"NakedDriOrderListView"];
    [mainContentView addSubview:mScrollPageView];
    [self.view addSubview:mainContentView];
    
    [mainContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [menuHorizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainContentView).offset(0);
        make.left.equalTo(mainContentView).offset(0);
        make.right.equalTo(mainContentView).offset(0);
        make.height.mas_equalTo(40);
    }];
    [mScrollPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainContentView).offset(0);
        make.top.equalTo(menuHorizontalView.mas_bottom).with.offset(0);
        make.bottom.equalTo(mainContentView).offset(0);
        make.right.equalTo(mainContentView).offset(0);
    }];
    //回到主线程选中第index个
    dispatch_async(dispatch_get_main_queue(), ^{
        [menuHorizontalView clickButtonAtIndex:_index];
    });
}
#pragma mark - 其他辅助功能
- (void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)index{
    _index = (int)index;
    [mScrollPageView moveScrollowViewAthIndex:index];
}

#pragma mark ScrollPageViewDelegate
- (void)didScrollPageViewChangedPage:(NSInteger)page{
    _index = (int)page;
    [menuHorizontalView changeButtonStateAtIndex:page];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
