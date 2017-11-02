//
//  NakedDriDetailOrderVc.m
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriDetailOrderVc.h"
#import "NakedDriOrderDetailCell.h"
#import "NakedDriDetailHeadV.h"
#import "PayViewController.h"
#import "NakedDriDetailHInfo.h"
#import "NakedDriDetailLInfo.h"
#import "NakedDriListOrderVc.h"
@interface NakedDriDetailOrderVc ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NakedDriDetailHeadV *headView;
@property (nonatomic,strong)NSArray *dataArr;
@end

@implementation NakedDriDetailOrderVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self setupTableView];
    [self setupTableHeadView];
    [self setupHomeData];
    if (self.isCon) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_return"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
}

- (void)back{
    NakedDriListOrderVc *orderVc = [NakedDriListOrderVc new];
    [self.navigationController pushViewController:orderVc animated:YES];
}

- (void)setupTableView{
    [self.payBtn setLayerWithW:3 andColor:BordColor andBackW:0.001];
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view.backgroundColor = DefaultColor;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)setupTableHeadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 270)];
    NakedDriDetailHeadV *headV = [[NakedDriDetailHeadV alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 270)];
    [headView addSubview:headV];
    self.tableView.tableHeaderView = headView;
    self.headView = headV;
}

- (void)setupHomeData{
    NSString *url = [NSString stringWithFormat:@"%@stoneOrderDetailpage",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = self.orderId;
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data]){
                NakedDriDetailHInfo *hInfo = [NakedDriDetailHInfo objectWithKeyValues:response.data];
                self.headView.hInfo = hInfo;
                BOOL isPay = [response.data[@"isNeetPay"]boolValue];
                self.payBtn.hidden = !isPay;
                if ([YQObjectBool boolForObject:response.data[@"list"]]) {
                    self.dataArr = [NakedDriDetailLInfo objectArrayWithKeyValuesArray:response.data[@"list"]];
                }
                [self.tableView reloadData];
            }
        }
    } requestURL:url params:params];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NakedDriOrderDetailCell *cell = [NakedDriOrderDetailCell cellWithTableView:tableView];
    NakedDriDetailLInfo *info = self.dataArr[indexPath.row];
    cell.lInfo = info;
    return cell;
}

- (IBAction)gotoPay:(id)sender {
    PayViewController *payVc = [PayViewController new];
    payVc.orderId = self.orderId;
    payVc.isStone = YES;
    [self.navigationController pushViewController:payVc animated:YES];
}

@end
