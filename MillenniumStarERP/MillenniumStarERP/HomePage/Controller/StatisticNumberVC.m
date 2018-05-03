//
//  StatisticNumberVC.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/11.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "StatisticNumberVC.h"
#import "StaticNumInfo.h"
#import "StaticNumberCell.h"
#import "StaticImgCell.h"
#import "FMDataTool.h"
#import "StrWithIntTool.h"
#import "SetDriInfo.h"
#import "SetDriViewController.h"
@interface StatisticNumberVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (nonatomic,  copy) NSArray *listArr;
@end

@implementation StatisticNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下单统计";
    [self createTableView];
    [self creatNaviBtn];
    // 9.0以上才有这个属性，针对ipad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0){
        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:)
         name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadStatisHomeData];
}

- (void)orientChange:(NSNotification *)notification{
    [self.tableView reloadData];
}

- (void)creatNaviBtn{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置"
     style:UIBarButtonItemStyleDone target:self action:@selector(setNumClick)];
}

- (void)setNumClick{
    SetDriViewController *driVc = [SetDriViewController new];
    [self.navigationController pushViewController:driVc animated:YES];
}

- (void)loadStatisHomeData{
    NSString *regiUrl = [NSString stringWithFormat:
                         @"%@GetUserCurrentModelWeightRangeQrt",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    NSArray *values = [[FMDataTool sharedDataBase]getAllSelDriInfo];
    NSMutableArray *mutA = [NSMutableArray new];
    for (SetDriInfo *info in values) {
        [mutA addObject:info.scope];
    }
    params[@"Ranges"] = [StrWithIntTool strWithArr:mutA With:@","];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"ranges"]]) {
                self.listArr = [StaticNumInfo mj_objectArrayWithKeyValuesArray:response.data[@"ranges"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }else{
            [MBProgressHUD showError:response.message];
        }
    } requestURL:regiUrl params:params];
}

- (void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view ).offset(44);
        make.left.equalTo(self.view ).offset(0);
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.0001f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 5.0f;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==0) {
//        StaticNumberCell *cell = [StaticNumberCell cellWithTableView:tableView];
//        cell.infoArr = self.listArr;
//        return cell;
//    }else{
//        StaticImgCell *cell = [StaticImgCell cellWithTableView:tableView];
//        StaticNumInfo *info = self.listArr[indexPath.section-1];
//        cell.numInfo = info;
//        return cell;
//    }
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"number";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.detailTextLabel.textColor = MAIN_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    StaticNumInfo *info = self.listArr[indexPath.row];
    cell.textLabel.text = info.rangeTitle;
    cell.detailTextLabel.text = info.count;
    return cell;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
