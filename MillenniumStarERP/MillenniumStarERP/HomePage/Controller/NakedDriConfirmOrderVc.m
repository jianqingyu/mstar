//
//  NakedDriConfirmOrderVc.m
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriConfirmOrderVc.h"
#import "NakedDriConfirmHeadV.h"
#import "NakedDriConfirmCell.h"
#import "AddressInfo.h"
#import "CustomerInfo.h"
#import "StrWithIntTool.h"
#import "DetailTypeInfo.h"
#import "SearchCustomerVC.h"
#import "ChooseAddressVC.h"
#import "InvoiceViewController.h"
#import "NakedDriConfirmInfo.h"
#import "NakedDriDetailOrderVc.h"
@interface NakedDriConfirmOrderVc ()<UITableViewDelegate,UITableViewDataSource,NakedDriConfirmHeadVDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (weak, nonatomic) NakedDriConfirmHeadV *headView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)CustomerInfo *cusInfo;
@property (nonatomic,strong)AddressInfo *addressInfo;
@property (nonatomic,strong)DetailTypeInfo *invoInfo;
@property (nonatomic,assign)BOOL isSelBtn;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@end

@implementation NakedDriConfirmOrderVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    [self setupBaseTableView];
    [self setupTableHeadView];
    [self loadHomeData];
    [self.bottomBtn setLayerWithW:3 andColor:BordColor andBackW:0.001];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isSelBtn = NO;
}

- (void)loadHomeData{
    NSString *url = [NSString stringWithFormat:@"%@stoneOrderListPage",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.orderId;
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    if (_percent.length>0) {
        params[@"tokenKey"] = _percent;
    }
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"address"]]) {
                self.addressInfo = [AddressInfo objectWithKeyValues:response.data[@"address"]];
            }
            if ([YQObjectBool boolForObject:response.data[@"customer"]]) {
                self.cusInfo = [CustomerInfo objectWithKeyValues:response.data[@"customer"]];
            }
            if ([YQObjectBool boolForObject:response.data[@"list"]]) {
                NSArray *arr = [NakedDriConfirmInfo objectArrayWithKeyValuesArray:response.data[@"list"]];
                for (NakedDriConfirmInfo *info in arr) {
                    info.number = 1;
                }
                self.dataArray = arr.mutableCopy;
            }
            [self.tableView reloadData];
            [self syncPriceLabel];
        }
    } requestURL:url params:params];
}

- (void)setupBaseTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = DefaultColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)setupTableHeadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 235)];
    headView.backgroundColor = DefaultColor;
    NakedDriConfirmHeadV *headV = [[NakedDriConfirmHeadV alloc]initWithFrame:CGRectZero];
    headV.delegate = self;
    [headView addSubview:headV];
    [headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(0);
        make.top.equalTo(headView).offset(0);
        make.bottom.equalTo(headView).offset(-10);
        make.right.equalTo(headView).offset(0);
    }];
    self.tableView.tableHeaderView = headView;
    self.headView = headV;
}
//选择客户
- (void)setCusInfo:(CustomerInfo *)cusInfo{
    if (cusInfo) {
        _cusInfo = cusInfo;
        self.headView.customFie.text = cusInfo.customerName;
    }
}
//选择地址
- (void)setAddressInfo:(AddressInfo *)addressInfo{
    if (addressInfo) {
        _addressInfo = addressInfo;
        self.headView.addInfo = _addressInfo;
    }
}
#pragma mark -- 头视图的点击事件 HeadViewDelegate
- (void)btnClick:(NakedDriConfirmHeadV *)headView andIndex:(NSInteger)index andMes:(NSString *)mes{
    switch (index) {
        case 0:
            [self pushEditVC];
            break;
        case 1:
            if (self.isSelBtn) return;
            [self pushSearchVC];
            break;
        case 2:
            [self pushInvoiceVc];
            break;
        case 3:
            [self loadHaveCustomer:mes];
        default:
            break;
    }
}

- (void)pushEditVC{
    ChooseAddressVC *editVc = [ChooseAddressVC new];
    editVc.addBack = ^(AddressInfo *info){
        self.addressInfo = info;
    };
    [self.navigationController pushViewController:editVc animated:YES];
}

- (void)pushSearchVC{
    SearchCustomerVC *cusVc = [SearchCustomerVC new];
    cusVc.searchMes = self.headView.customFie.text;
    cusVc.back = ^(id dict){
        self.cusInfo = dict;
    };
    [self.navigationController pushViewController:cusVc animated:YES];
}

- (void)pushInvoiceVc{
    InvoiceViewController *InvoVc = [InvoiceViewController new];
    InvoVc.invoInfo = self.invoInfo;
    InvoVc.invoBack = ^(id dict){
        self.invoInfo = dict;
        if (self.invoInfo.price) {
            NSString *invoStr = [NSString stringWithFormat:@"类型:%@ 抬头:%@",
                                 self.invoInfo.title,self.invoInfo.price];
            self.headView.invoMes = invoStr;
        }else{
            self.headView.invoMes = self.invoInfo.title;
        }
    };
    [self.navigationController pushViewController:InvoVc animated:YES];
}

- (void)loadHaveCustomer:(NSString *)message{
    if (self.isSelBtn) {
        return;
    }
    self.isSelBtn = YES;
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@IsHaveCustomer",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"keyword"] = message;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        self.isSelBtn = NO;
        if ([response.error intValue]==0&&[YQObjectBool boolForObject:response.data]) {
            if ([response.data[@"state"]intValue]==0) {
                SHOWALERTVIEW(@"没有此客户记录");
                self.cusInfo.customerID = 0;
            }else if([response.data[@"state"]intValue]==1){
                self.cusInfo = [CustomerInfo objectWithKeyValues:response.data[@"customer"]];
            }else if ([response.data[@"state"]intValue]==2){
                [self pushSearchVC];
            }
        }else{
            [MBProgressHUD showError:response.message];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NakedDriConfirmCell *cell = [NakedDriConfirmCell cellWithTableView:tableView];
    cell.back = ^(BOOL isDel){
        [self editCellWith:isDel andIdx:indexPath.section];
    };
    cell.conInfo = self.dataArray[indexPath.section];
    return cell;
}

- (void)editCellWith:(BOOL)isDel andIdx:(NSInteger)idx{
    if (isDel) {
        [self.dataArray removeObjectAtIndex:idx];
    }
    [self.tableView reloadData];
    [self syncPriceLabel];
}

#pragma mark -- 底部的价格与按钮
//更新价格
- (void)syncPriceLabel{
    double value = 0.0;
    if (_dataArray.count){
        for (NakedDriConfirmInfo *info in _dataArray){
            value = value+info.price*info.number;
        }
    }
    NSString *dePrice = [OrderNumTool strWithPrice:value];
    self.bottomLab.text = [NSString stringWithFormat:@"合计:%@",dePrice];
}

- (IBAction)confirmClick:(id)sender {
    if (!self.addressInfo) {
        [MBProgressHUD showError:@"请选择地址"];
        return;
    }
    if (!self.cusInfo.customerID) {
        [MBProgressHUD showError:@"请选择客户"];
        return;
    }
    if (!self.dataArray.count) {
        [MBProgressHUD showError:@"没有钻石"];
        return;
    }
    [self submitOrders];
}

- (void)submitOrders{
    NSMutableArray *mutArr = [NSMutableArray array];
    for (NakedDriConfirmInfo *info in _dataArray) {
        NSString *str = [NSString stringWithFormat:@"%@,%d",info.id,info.number];
        [mutArr addObject:str];
    }
    NSString *url = [NSString stringWithFormat:@"%@stoneSubmitOrderDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"id"] = [StrWithIntTool strWithArr:mutArr With:@"|"];
    params[@"addressId"] = @(self.addressInfo.id);
    if (self.headView.noteLab.text.length>0) {
        params[@"remark"] = _headView.noteLab.text;
    }
    if (self.invoInfo.title.length>0) {
        params[@"invTitle"] = self.invoInfo.price;
        params[@"invType"] = @(self.invoInfo.id);
    }
    params[@"customerId"] = @(self.cusInfo.customerID);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:@"提交成功"];
            if ([YQObjectBool boolForObject:response.data]) {
                NakedDriDetailOrderVc *orderVC = [NakedDriDetailOrderVc new];
                orderVC.isCon = YES;
                orderVC.orderId = response.data[@"orderId"];
                [self.navigationController pushViewController:orderVC animated:YES];
            }
        }else{
            [MBProgressHUD showError:response.message];
        }
    } requestURL:url params:params];
}

@end
