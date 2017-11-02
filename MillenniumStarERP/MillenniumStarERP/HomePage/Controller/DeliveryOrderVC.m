//
//  DeliveryOrderVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/3.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "DeliveryOrderVC.h"
#import "DeliveryListInfo.h"
#import "DeliveryHeadInfo.h"
#import "DeliveryOrderHeadView.h"
#import "DeliveryOrderTableCell.h"
@interface DeliveryOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak,  nonatomic) IBOutlet UITableView *deliveryTab;
@property (nonatomic,strong)NSArray *listArr;
@property (nonatomic,  weak)DeliveryOrderHeadView *delHView;
@end

@implementation DeliveryOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"出货单";
    [self setBaseView];
    [self loadDeliveryData];
}

- (void)setBaseView{
    self.deliveryTab.backgroundColor = DefaultColor;
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 120)];
    DeliveryOrderHeadView *headView = [DeliveryOrderHeadView createHeadView];
    [headV addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headV).offset(0);
        make.bottom.equalTo(headV).offset(0);
        make.left.equalTo(headV).offset(0);
        make.right.equalTo(headV).offset(0);
    }];
    self.deliveryTab.tableHeaderView = headV;
    self.deliveryTab.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.delHView = headView;
}

- (void)loadDeliveryData{
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *str = self.isSea?@"ModelArriveBillMoForSearch":@"ModelArriveBillMo";
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,str];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"moNum"] = self.orderNum;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"moItem"]]) {
                DeliveryHeadInfo *info = [DeliveryHeadInfo
                                    objectWithKeyValues:response.data[@"moItem"]];
                self.delHView.delHInfo = info;
            }
            if ([YQObjectBool boolForObject:response.data[@"modelList"]]) {
                self.listArr = [DeliveryListInfo objectArrayWithKeyValuesArray:
                                response.data[@"modelList"]];
                [self.deliveryTab reloadData];
            }
        }
    } requestURL:url params:params];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeliveryListInfo *sInfo = self.listArr[indexPath.row];
    return sInfo.isOpen?130+sInfo.stInfo.count*20:80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeliveryOrderTableCell *cell = [DeliveryOrderTableCell cellWithTableView:tableView];
    DeliveryListInfo *sInfo = self.listArr[indexPath.row];
    cell.deliveryInfo = sInfo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DeliveryListInfo *sInfo = self.listArr[indexPath.row];
    sInfo.isOpen = !sInfo.isOpen;
    [_deliveryTab reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationNone];
}

@end
