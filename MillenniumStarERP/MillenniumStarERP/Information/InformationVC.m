//
//  InformationVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/5.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "InformationVC.h"
#import "InformationCell.h"
#import "MessageInfo.h"
#import "ZBButten.h"
@interface InformationVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSArray *listArr;
@end

@implementation InformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信息";
    [self setBaseViewData];
    [self loadInfoData];
}

- (void)setBaseViewData{
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
}

- (void)loadInfoData{
    NSString *regiUrl = [NSString stringWithFormat:@"%@userMessagePageList",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"cpage"] = @1;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0&&[YQObjectBool boolForObject:response.data]) {
            self.listArr = [MessageInfo objectArrayWithKeyValuesArray:response.data[@"messageList"]];
            [self.tableView reloadData];
        }else{
            SHOWALERTVIEW(response.message);
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InformationCell *infoCell = [InformationCell cellWithTableView:tableView];
    MessageInfo *info = self.listArr[indexPath.row];
    infoCell.messInfo = info;
    return infoCell;
}

@end
