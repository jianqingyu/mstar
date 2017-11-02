//
//  SettlementDetailView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/16.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SettlementDetailView.h"
#import "OrderSetmentInfo.h"
#import "DelSListInfo.h"
#import "SettlementListHeadView.h"
#import "SettlementListCell.h"
#import "DeliveryOrderVC.h"
#import "SettlementOrderVC.h"
#import "ShowPriceHeadView.h"
#import "CustomInputPassView.h"
@interface SettlementDetailView()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_mTableView;
}
@property (nonatomic,assign)BOOL isShow;
@property (nonatomic,  weak)ShowPriceHeadView *headView;
@property (nonatomic,  weak)CustomInputPassView *putView;
@end
@implementation SettlementDetailView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTableView];
    }
    return self;
}

- (void)setupTableView{
    _mTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.backgroundColor = DefaultColor;
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:_mTableView];
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0); 
        make.bottom.equalTo(self).offset(0);
    }];
    StorageDataTool *data = [StorageDataTool shared];
    if (data.isMain) {
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 44)];
        ShowPriceHeadView *headV = [ShowPriceHeadView view];
        headV.frame = CGRectMake(0, 0, SDevWidth, 44);
        [head addSubview:headV];
        [headV.showBtn addTarget:self action:@selector(ClickOn:) forControlEvents:UIControlEventTouchUpInside];
        _mTableView.tableHeaderView = head;
        self.headView = headV;
        
        CustomInputPassView *pass = [CustomInputPassView new];
        pass.hidden = YES;
        pass.clickBlock = ^(BOOL isYes){
            if (isYes) {
                self.isShow = !self.isShow;
                [_mTableView reloadData];
            }else{
                [MBProgressHUD showError:@"密码错误"];
            }
            self.putView.hidden = YES;
            [self.headView.showBtn setOn:self.isShow];
        };
        [self addSubview:pass];
        [pass mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.left.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.bottom.equalTo(self).offset(0);
        }];
        self.putView = pass;
    }
}

- (void)ClickOn:(UISwitch *)swBtn{
    self.putView.hidden = NO;
}

- (void)setDict:(NSDictionary *)dict{
    if (dict) {
        _dict = dict;
        [_mTableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dict[@"orderList"]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dict[@"orderList"];
    OrderSetmentInfo *list = arr[section];
    return list.moList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 180.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 180)];
    SettlementListHeadView *headView = [SettlementListHeadView createHeadView];
    [headV addSubview:headView];
    headView.backgroundColor = DefaultColor;
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headV).offset(0);
        make.bottom.equalTo(headV).offset(0);
        make.left.equalTo(headV).offset(0);
        make.right.equalTo(headV).offset(0);
    }];
    headView.isShow = self.isShow;
    NSArray *arr = self.dict[@"orderList"];
    OrderSetmentInfo *list = arr[section];
    headView.headInfo = list;
    headView.clickBack = ^(BOOL isClick){
        [self loadSettlementVC:section];
    };
    return headV;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettlementListCell *listCell = [SettlementListCell cellWithTableView:tableView];
    listCell.isShow = self.isShow;
    NSArray *arr = self.dict[@"orderList"];
    OrderSetmentInfo *list = arr[indexPath.section];
    listCell.listInfo = list.moList[indexPath.row];
    return listCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self loadDeliveryWithIndex:indexPath];
}
//出货单
- (void)loadDeliveryWithIndex:(NSIndexPath *)indexPath{
    if (!self.isShow) {
//        [MBProgressHUD showError:@"不显示价格不可查看"];
        return;
    }
    NSArray *arr = self.dict[@"orderList"];
    OrderSetmentInfo *list = arr[indexPath.section];
    DelSListInfo *sInfo = list.moList[indexPath.row];
    DeliveryOrderVC *orderVc = [DeliveryOrderVC new];
    orderVc.orderNum = sInfo.moNum;
    orderVc.isSea = [self.dict[@"isSearch"]intValue];
    [self.superNav pushViewController:orderVc animated:YES];
}
//结算单
- (void)loadSettlementVC:(NSInteger)section{
    if (!self.isShow) {
        return;
    }
    NSArray *arr = self.dict[@"orderList"];
    OrderSetmentInfo *list = arr[section];
    SettlementOrderVC *orderVc = [SettlementOrderVC new];
    orderVc.orderNum = list.recNum;
    orderVc.isSea = [self.dict[@"isSearch"]intValue];
    [self.superNav pushViewController:orderVc animated:YES];
}

@end
