//
//  SettlementOrderVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/3.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SettlementOrderVC.h"
#import "SettlementHeadInfo.h"
#import "SettlementListInfo.h"
#import "SettlementSecHedView.h"
#import "SettlementHeadView.h"
#import "SettlementTableCell.h"
#import "SettlementFootView.h"
#import "ArrayWithDict.h"
@interface SettlementOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *settlementTab;
@property (nonatomic,strong) NSArray *listArr;
@property (nonatomic,  weak) SettlementHeadView *delHView;
@property (nonatomic,  weak) SettlementFootView *delFView;
@end

@implementation SettlementOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"结算单";
    [self setBaseView];
    [self loadSetmentData];
}

- (void)setBaseView{
    self.settlementTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.settlementTab.delegate = self;
    self.settlementTab.dataSource = self;
    [self.view addSubview:self.settlementTab];
    [self.settlementTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    if (@available(iOS 11.0, *)) {
        self.settlementTab.estimatedRowHeight = 0;
        self.settlementTab.estimatedSectionHeaderHeight = 0;
        self.settlementTab.estimatedSectionFooterHeight = 0;
    }
    self.settlementTab.backgroundColor = DefaultColor;
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 130)];
    headV.backgroundColor = DefaultColor;
    SettlementHeadView *headView = [SettlementHeadView createHeadView];
    [headV addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headV).offset(0);
        make.bottom.equalTo(headV).offset(-10);
        make.left.equalTo(headV).offset(0);
        make.right.equalTo(headV).offset(0);
    }];
    
    UIView *footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 90)];
    SettlementFootView *footView = [SettlementFootView createHeadView];
    [footV addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footV).offset(0);
        make.bottom.equalTo(footV).offset(0);
        make.left.equalTo(footV).offset(0);
        make.right.equalTo(footV).offset(0);
    }];
    
    self.settlementTab.tableHeaderView = headV;
    self.settlementTab.tableFooterView = footV;
    self.delHView = headView;
    self.delFView = footView;
}

- (void)loadSetmentData{
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *str = self.isSea?@"ModelBillFinishDetailRecForSearch"
                                                   :@"ModelBillFinishDetailRec";
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,str];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"recNum"] = self.orderNum;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0&&[YQObjectBool boolForObject:response.data]) {
            if ([YQObjectBool boolForObject:response.data[@"recItem"]]) {
                SettlementHeadInfo *info = [SettlementHeadInfo
                                 mj_objectWithKeyValues:response.data[@"recItem"]];
                self.delHView.headInfo = info;
                self.delFView.footInfo = info;
            }
            self.listArr = @[[self setData:response.data andStr:@"recMaterials"],
                             [self setData:response.data andStr:@"recOtherProcessExpenseses"],
                             [self setData:response.data andStr:@"recProcessExpenseses"],
                             [self setData:response.data andStr:@"recStones"]];
            [self.settlementTab reloadData];
        }
    } requestURL:url params:params];
}

- (SettlementListInfo *)setData:(NSDictionary *)dict andStr:(NSString *)key{
    NSDictionary *dic = dict[key];
    SettlementListInfo *sInfo = [SettlementListInfo mj_objectWithKeyValues:dic];
    NSDictionary *par = @{key:dic};
    sInfo.list = [ArrayWithDict DateWithDict:par];
    return sInfo;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 11.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SettlementListInfo *sInfo = self.listArr[section];
    SettlementSecHedView *headV = [SettlementSecHedView creatView];
    headV.secInfo = sInfo;
    return headV;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 11)];
    footV.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SDevWidth, 1)];
    line .backgroundColor = DefaultColor;
    [footV addSubview:line];
    return footV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettlementListInfo *sInfo = self.listArr[indexPath.section];
    return 24*sInfo.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettlementTableCell *cell = [SettlementTableCell cellWithTableView:tableView];
    SettlementListInfo *sInfo = self.listArr[indexPath.section];
    cell.info = sInfo;
    return cell;
}

@end
