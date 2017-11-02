//
//  EditShowPriceVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/8/4.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "EditShowPriceVC.h"
#import "EditUserInfoCell.h"
#import "MasterCountInfo.h"
@interface EditShowPriceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,  copy)NSArray *textArr;
@property (nonatomic,strong)MasterCountInfo *masterInfo;
@property (nonatomic,  weak)EditUserInfoCell *editCell;
@end

@implementation EditShowPriceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self setBaseViewData];
    [self loadUserInfoData];
}

- (void)setBaseViewData{
    self.textArr = @[@"是否显示戒托价格",@"是否显示裸钻价格",@"是否高级定制"];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    // 9.0以上才有这个属性，针对ipad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0){
        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)loadUserInfoData{
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@userModifyPage",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data]) {
                int master = [response.data[@"isMasterAccount"]intValue];
                self.masterInfo = [MasterCountInfo objectWithKeyValues:response.data];
                if (master) {
                    self.textArr = @[@"是否显示戒托价格",@"是否显示裸钻价格",@"是否高级定制",@"是否显示成本价"];
                }
                [self.tableView reloadData];
            }
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSString *driUrl = [NSString stringWithFormat:@"%@modifyUserModelAddtionDo",baseUrl];
    NSMutableDictionary *driparams = [NSMutableDictionary dictionary];
    driparams[@"tokenKey"] = [AccountTool account].tokenKey;
    driparams[@"value"] = self.editCell.shopFie.text;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
    } requestURL:driUrl params:driparams];
    
    NSString *regiUrl = [NSString stringWithFormat:@"%@modifyUserStoneAddtionDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"value"] = self.editCell.driFie.text;
    params[@"value1"] = self.editCell.dri2Fie.text;
    params[@"value2"] = self.editCell.dri3Fie.text;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
    } requestURL:regiUrl params:params];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.textArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==3) {
        return 245;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableCell =  [tableView cellForRowAtIndexPath:indexPath];
    if (tableCell == nil){
        tableCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:@"myCell"];
        tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableCell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    NSString *key = self.textArr[indexPath.row];
    tableCell.textLabel.text = key;
    if(indexPath.row==0){
        UISwitch *switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        [switchBtn setOn:![[AccountTool account].isNoShow intValue]];
        tableCell.accessoryView = switchBtn;
        [switchBtn addTarget:self action:@selector(showPriceClick:)
            forControlEvents:UIControlEventTouchUpInside];
    }else if(indexPath.row==1){
        UISwitch *switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        [switchBtn setOn:![[AccountTool account].isNoDriShow intValue]];
        tableCell.accessoryView = switchBtn;
        [switchBtn addTarget:self action:@selector(showDriClick:)
            forControlEvents:UIControlEventTouchUpInside];
    }else if(indexPath.row==2){
        UISwitch *switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        [switchBtn setOn:[[AccountTool account].isNorm intValue]];
        tableCell.accessoryView = switchBtn;
        [switchBtn addTarget:self action:@selector(easyClick:)
            forControlEvents:UIControlEventTouchUpInside];
    }else{
        tableCell = [EditUserInfoCell cellWithTableView:tableView];
        [tableCell setValue:self.masterInfo forKey:@"mInfo"];
        self.editCell = (EditUserInfoCell *)tableCell;
    }
    return tableCell;
}

- (void)showPriceClick:(UISwitch *)btn{
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"userName"] = [AccountTool account].userName;
    params[@"password"] = [AccountTool account].password;
    params[@"phone"] = [AccountTool account].phone;
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"isNorm"] = [AccountTool account].isNorm;
    params[@"isNoDriShow"] = [AccountTool account].isNoDriShow;
    params[@"isNoShow"] = @(!btn.on);
    Account *account = [Account accountWithDict:params];
    //自定义类型存储用NSKeyedArchiver
    [AccountTool saveAccount:account];
    [MBProgressHUD showSuccess:@"修改成功"];
}

- (void)showDriClick:(UISwitch *)btn{
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"userName"] = [AccountTool account].userName;
    params[@"password"] = [AccountTool account].password;
    params[@"phone"] = [AccountTool account].phone;
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"isNorm"] = [AccountTool account].isNorm;
    params[@"isNoShow"] = [AccountTool account].isNoShow;
    params[@"isNoDriShow"] = @(!btn.on);
    Account *account = [Account accountWithDict:params];
    //自定义类型存储用NSKeyedArchiver
    [AccountTool saveAccount:account];
    [MBProgressHUD showSuccess:@"修改成功"];
}

- (void)easyClick:(UISwitch *)btn{
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"userName"] = [AccountTool account].userName;
    params[@"password"] = [AccountTool account].password;
    params[@"phone"] = [AccountTool account].phone;
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"isNoShow"] = [AccountTool account].isNoShow;
    params[@"isNoDriShow"] = [AccountTool account].isNoDriShow;
    params[@"isNorm"] = @(btn.on);
    Account *account = [Account accountWithDict:params];
    //自定义类型存储用NSKeyedArchiver
    [AccountTool saveAccount:account];
    [MBProgressHUD showSuccess:@"修改成功"];
}

@end
