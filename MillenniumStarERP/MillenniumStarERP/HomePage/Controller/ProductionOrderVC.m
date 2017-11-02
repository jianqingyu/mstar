//
//  ProductionOrderVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/11/21.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ProductionOrderVC.h"
#import "ProductionDetailView.h"
#import "OrderListInfo.h"
#import "ProduceOrderInfo.h"
#import "OrderListController.h"
@interface ProductionOrderVC ()
@property (nonatomic,  weak) ProductionDetailView *proView;
@end

@implementation ProductionOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生产中";
    [self creatProTabView];
    [self loadOrderDataWithBool:YES];
    if (self.isOrd) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_return"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
}

- (void)back{
    OrderListController *listVC = [OrderListController new];
    listVC.isOrd = self.isOrd;
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)creatProTabView{
    ProductionDetailView *proV = [[ProductionDetailView alloc]initWithFrame:CGRectZero];
    proV.back = ^(BOOL isLoad){
        [self loadOrderDataWithBool:isLoad];
    };
    [self.view addSubview:proV];
    [proV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.proView = proV;
    self.proView.superNav = self.navigationController;
}

- (void)loadOrderDataWithBool:(BOOL)isNew{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSString *netUrl = isNew?@"ModelOrderProduceDetailPage":
                             @"ModelOrderProduceDetailHistoryPage";
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,netUrl];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"orderNum"] = self.orderNum;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"modelList"]]) {
                NSArray *arr = [OrderListInfo objectArrayWithKeyValuesArray:response.data[@"modelList"]];
                dict[@"orderList"] = arr;
            }
            if ([YQObjectBool boolForObject:response.data[@"orderInfo"]]) {
                ProduceOrderInfo *info = [ProduceOrderInfo
                                objectWithKeyValues:response.data[@"orderInfo"]];
                dict[@"orderInfo"] = info;
            }
            dict[@"orderNum"] = self.orderNum;
            self.proView.dict = dict.copy;
        }
    } requestURL:url params:params];
}

@end
