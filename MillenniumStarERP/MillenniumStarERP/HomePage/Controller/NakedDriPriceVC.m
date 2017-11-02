//
//  NakedDriPriceVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriPriceVC.h"
#import "NakedDriPirceTableCell.h"
@interface NakedDriPriceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSArray *dataArr;
@end

@implementation NakedDriPriceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报价";
    [self setupBaseTableView];
    [self loadHomeData];
}

- (void)loadHomeData{
    NSString *url = [NSString stringWithFormat:@"%@stoneOffer",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.orderId;
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    if (_percent.length>0) {
        params[@"tokenKey"] = _percent;
    }
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"list"]]) {
                self.dataArr = response.data[@"list"];
            }
            [self.tableView reloadData];
        }
    } requestURL:url params:params];
}

- (void)setupBaseTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NakedDriPirceTableCell *cell = [NakedDriPirceTableCell cellWithTableView:tableView];
    NSDictionary *dic = self.dataArr[indexPath.section];
    cell.dataDic = dic;
    return cell;
}

@end
