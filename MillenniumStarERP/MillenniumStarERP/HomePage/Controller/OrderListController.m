//
//  OrderListController.m
//  MillenniumStarERP
//
//  Created by yjq on 16/10/26.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "OrderListController.h"
#import "SearchOrderVc.h"
#import "ConfirmOrderVC.h"
#import "UserManagerMenuHrizontal.h"
#import "UserManagerScrollPageView.h"
#define MENUHEIHT 40
@interface OrderListController ()<UserManagerMenuHrizontalDelegate,UserManagerScrollPageViewDelegate>{
    NSArray*titleArray;
    UserManagerScrollPageView*mScrollPageView;
    UserManagerMenuHrizontal*menuHorizontalView;
}
@end

@implementation OrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史订单";
    titleArray = @[@{@"title":@"待审核",@"netUrl":@"ModelOrderWaitCheckList",@"proId":@"10"},
                   @{@"title":@"生产中",@"netUrl":@"ModelOrderProduceListPage",@"proId":@"20"},
                   @{@"title":@"已发货",@"netUrl":@"ModelBillList",@"proId":@"30"},
                   @{@"title":@"已完成",@"netUrl":@"",@"proId":@"40"}];
    [self initCustomView];
    [self setNaviBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    if (self.isOrd) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_return"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
}

- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)orientChange:(NSNotification *)notification{
    [mScrollPageView moveScrollowViewToFirst];
}

- (void)setNaviBtn{
    UIButton *seaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seaBtn.frame = CGRectMake(0, 0, 30, 30);
    [seaBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [seaBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:seaBtn];
}

- (void)searchClick{
    SearchOrderVc *seaVc = [SearchOrderVc new];
    [self.navigationController pushViewController:seaVc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(headBtnNum:)
                                              name:NotificationList object:nil];
}
//显示条数
- (void)headBtnNum:(NSNotification *)notification{
    NSMutableArray *arr = notification.userInfo[ListNum];
    menuHorizontalView.imgArr = arr.copy;
}
#pragma mark UI初始化
- (void)initCustomView{
    //main view
    UIView *mainContentView = [[UIView alloc] init];
    menuHorizontalView = [[UserManagerMenuHrizontal alloc] initWithFrame:CGRectZero ButtonItems:titleArray];
    menuHorizontalView.delegate = self;
    [mainContentView addSubview:menuHorizontalView];

    //初始化滑动列表
    mScrollPageView = [[UserManagerScrollPageView alloc] initScrollPageView:CGRectZero navigation:self.navigationController];
    mScrollPageView.delegate = self;
    [mScrollPageView setContentOfTables:titleArray andId:@"UserManagerTableView"];
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
