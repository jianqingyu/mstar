//
//  ProgressOrderVc.m
//  MillenniumStarERP
//
//  Created by yjq on 16/12/20.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ProgressOrderVc.h"
#import "ProgressHeadView.h"
#import "ProgressListCell.h"
#import "ProOrderInfo.h"
#import "ProgressListInfo.h"
@interface ProgressOrderVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,weak)ProgressHeadView *headEView;
@property (nonatomic,strong)NSArray *proListArr;
@property (nonatomic,assign)float totalCount;
@end

@implementation ProgressOrderVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"进度";
    [self setupTableView];
    [self setupTableHeadView];
    [self loadProgressData];
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
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

- (void)setupTableHeadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 98)];
    headView.backgroundColor = DefaultColor;
    ProgressHeadView *headV = [ProgressHeadView createHeadView];
    headV.frame = CGRectMake(0, 0, SDevWidth, 98);
    [headView addSubview:headV];
    self.tableView.tableHeaderView = headView;
    self.headEView = headV;
}

- (void)loadProgressData{
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *str = self.isSea?@"ModelOrderProduceDetailShowRateProgressPageForSearch":
                                  @"ModelOrderProduceDetailShowRateProgressPage";
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,str];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"orderNum"] = self.orderNum;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"orderlList"]]) {
                self.proListArr = [ProgressListInfo objectArrayWithKeyValuesArray:
                                             response.data[@"orderlList"]];
                if (response.data[@"flowTotalCount"]) {
                    self.totalCount = [response.data[@"flowTotalCount"]floatValue];
                }
                [self.tableView reloadData];
            }
            if ([YQObjectBool boolForObject:response.data[@"orderInfo"]]) {
                self.headEView.orderInfo = [ProOrderInfo
                            objectWithKeyValues:response.data[@"orderInfo"]];
            }
        }
    } requestURL:url params:params];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.proListArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProgressListInfo *progressI = self.proListArr[indexPath.section];
    return 90+(progressI.progress.count)*(proHeight+proMar);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProgressListCell *progressCell = [ProgressListCell cellWithTableView:tableView];
    progressCell.totalNum = self.totalCount;
    ProgressListInfo *progress = self.proListArr[indexPath.section];
    progressCell.proInfo = progress;
    return  progressCell;
}

@end
