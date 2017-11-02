//
//  EditAddressVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/7.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "EditAddressVC.h"
#import "EditAddressCell.h"
#import "AddEditAddressVC.h"
#import "AddressInfo.h"
@interface EditAddressVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSArray *listArr;
@end

@implementation EditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    self.view.backgroundColor = DefaultColor;
    [self setBaseViewData];
    [self setupFootView];
    [self loadHomeData];
}

- (void)setBaseViewData{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = DefaultColor;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-60);
    }];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
}

- (void)setupFootView{
    UIView *foot = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:foot];
    [foot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(@60);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setImage:[UIImage imageNamed:@"icon_+"] forState:UIControlStateNormal];
    [btn setTitle:@"新增" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(SDevWidth*0.1, 10, SDevWidth*0.8, 40);
    [btn setLayerWithW:5.0 andColor:DefaultColor andBackW:1];
    [foot addSubview:btn];
    [btn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadHomeData{
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@AddressListPage",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0&&[YQObjectBool boolForObject:response.data]) {
            self.listArr = [AddressInfo objectArrayWithKeyValuesArray:response.data[@"addressList"]];
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:response.message];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (void)addClick:(id)sender{
    AddEditAddressVC *editVc = [AddEditAddressVC new];
    editVc.block = ^(BOOL isSuccees) {
        if(isSuccees)
        {
            [self loadHomeData];
        }
    };
    [self.navigationController pushViewController:editVc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 145;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EditAddressCell *addressCell = [EditAddressCell cellWithTableView:tableView];
    AddressInfo *addInfo = self.listArr[indexPath.section];
    addressCell.addInfo = addInfo;
    __weak __typeof(&*self)weakSelf = self;
    addressCell.didClick = ^(NSInteger index){
        switch (index) {
            case 0:
                [weakSelf setDefault:addInfo];
                break;
            case 1:
                [weakSelf editAdd:addInfo.id];
                break;
            case 2:
                [weakSelf deleteAdd:addInfo.id];
                break;
            default:
                break;
        }
    };
    return addressCell;
}

- (void)gotoAddEditVc:(int)addId{
    AddEditAddressVC *editVc = [AddEditAddressVC new];
    editVc.addId = addId;
    editVc.block = ^(BOOL isSuccees) {
        if(isSuccees)
        {
            [self loadHomeData];
        }
    };
    [self.navigationController pushViewController:editVc animated:YES];
}
//底部3个按钮
- (void)setDefault:(AddressInfo *)addInfo{
    if (addInfo.isDefault==1) {
        return;
    }
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@setDefaultAddressDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"id"] = @(addInfo.id);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:response.message];
            [self loadHomeData];
        }else{
            [MBProgressHUD showMessage:response.message];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (void)editAdd:(int)proid{
    [self gotoAddEditVc:proid];
}

- (void)deleteAdd:(int)proid{
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@deleteAddressDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"id"] = @(proid);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:response.message];
            [self loadHomeData];
        }else{
            [MBProgressHUD showError:response.message];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

@end
