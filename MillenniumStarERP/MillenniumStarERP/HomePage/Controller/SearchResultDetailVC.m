//
//  SearchResultDetailVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/15.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SearchResultDetailVC.h"
#import "UserManagerMenuHrizontal.h"
#import "UserManagerScrollPageView.h"
#import "OrderListInfo.h"
#import "ProduceOrderInfo.h"
#import "OrderSetmentInfo.h"
#import "DelSListInfo.h"

@interface SearchResultDetailVC ()<UserManagerMenuHrizontalDelegate,UserManagerScrollPageViewDelegate>{
    NSMutableArray *titleArray;
    NSMutableArray *strArr;
    NSMutableArray *dataArr;
    UserManagerScrollPageView*mScrollPageView;
    UserManagerMenuHrizontal*menuHorizontalView;
}
@end

@implementation SearchResultDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索结果";
    titleArray = [NSMutableArray new];
    dataArr = [NSMutableArray new];
    strArr = [NSMutableArray new];
    [self loadSearchResultData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)orientChange:(NSNotification *)notification{
    [mScrollPageView moveScrollowViewToFirst];
}

- (void)loadSearchResultData{
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *url = [NSString stringWithFormat:@"%@ModelOrderSearchDetail",baseUrl];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"orderNum"] = self.orderNum;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0&&[YQObjectBool boolForObject:response.data]) {
            [self setupListDataWith:response.data];
            if (titleArray.count>0) {
                [self initCustomView];
            }else{
                SHOWALERTVIEW(@"暂时没数据请返回");
            }
        }
    } requestURL:url params:params];
}
//更新数据
- (void)setupListDataWith:(NSDictionary *)dict{
    if ([YQObjectBool boolForObject:dict[@"orderProduce"]]) {
        NSMutableDictionary *mutDic = [NSMutableDictionary new];
        if ([YQObjectBool boolForObject:dict[@"orderProduce"][@"modelList"]]) {
            NSArray *arr = [OrderListInfo objectArrayWithKeyValuesArray:dict[@"orderProduce"][@"modelList"]];
            mutDic [@"orderList"] = arr;
        }
        if ([YQObjectBool boolForObject:dict[@"orderProduce"][@"orderInfo"]]) {
            ProduceOrderInfo *info = [ProduceOrderInfo
                                      objectWithKeyValues:dict[@"orderProduce"][@"orderInfo"]];
            mutDic [@"orderInfo"] = info;
        }
        mutDic [@"orderNum"] = self.orderNum;
        mutDic [@"isSearch"] = @1;
        [titleArray addObject:@{@"title":@"生产中"}];
        [strArr addObject:@"ProductionDetailView"];
        [dataArr addObject:mutDic];
    }
    if ([YQObjectBool boolForObject:dict[@"orderSended"]]) {
        NSMutableDictionary *mutDic = [NSMutableDictionary new];
        if ([YQObjectBool boolForObject:dict[@"orderSended"][@"recList"]]) {
            NSArray *arr = [OrderSetmentInfo objectArrayWithKeyValuesArray:
                            dict[@"orderSended"][@"recList"]];
            mutDic[@"orderList"] = arr;
        }
        mutDic[@"orderNum"] = self.orderNum;
        mutDic [@"isSearch"] = @1;
        [titleArray addObject:@{@"title":@"已发货"}];
        [strArr addObject:@"SettlementDetailView"];
        [dataArr addObject:mutDic];
    }
    if ([YQObjectBool boolForObject:dict[@"orderFinish"]]) {
        [titleArray addObject:@{@"title":@"已完成"}];
    }
}

#pragma mark UI初始化
- (void)initCustomView{
    //main view
    UIView *mainContentView = [[UIView alloc] init];
    menuHorizontalView = [[UserManagerMenuHrizontal alloc] initWithFrame:CGRectZero ButtonItems:titleArray];
    menuHorizontalView.delegate = self;
    //默认选中第一个button
    [menuHorizontalView clickButtonAtIndex:_index];
    [mainContentView addSubview:menuHorizontalView];
    
    //初始化滑动列表
    mScrollPageView = [[UserManagerScrollPageView alloc] initScrollPageView:CGRectZero navigation:self.navigationController];
    mScrollPageView.delegate = self;
    [mScrollPageView setContentOfTables:dataArr andId:strArr];
    [mainContentView addSubview:mScrollPageView];
    //初始化选择
    [mScrollPageView moveScrollowViewAthIndex:_index];
    [menuHorizontalView changeButtonStateAtIndex:_index];
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
