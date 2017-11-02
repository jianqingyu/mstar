//
//  SettlementListVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/7.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SettlementListVC.h"
#import "OrderSetmentInfo.h"
#import "DelSListInfo.h"
#import "SettlementDetailView.h"
@interface SettlementListVC ()
@property (nonatomic, weak)SettlementDetailView *setView;
@end

@implementation SettlementListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"结算单";
    [self setupSettlementView];
    [self loadSetListData];
}

- (void)setupSettlementView{
    SettlementDetailView *setV = [[SettlementDetailView alloc]init];
    [self.view addSubview:setV];
    [setV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.setView = setV;
    self.setView.superNav = self.navigationController;
}

- (void)loadSetListData{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *url = [NSString stringWithFormat:@"%@ModelFinishBillList",baseUrl];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"orderNum"] = self.orderNumber;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"recList"]]) {
                NSArray *arr = [OrderSetmentInfo objectArrayWithKeyValuesArray:
                                   response.data[@"recList"]];
                dict[@"orderList"] = arr;
                self.setView.dict = dict.copy;
            }
        }
    } requestURL:url params:params];
}

@end
