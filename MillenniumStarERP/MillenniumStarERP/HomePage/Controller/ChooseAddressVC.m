//
//  ChooseAddressVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/10/24.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ChooseAddressVC.h"
#import "ChooseAddressTableCell.h"
#import "EditAddressVC.h"
#import "AddEditAddressVC.h"
@interface ChooseAddressVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *addressTab;
@property (nonatomic,strong)NSArray *addressArray;
@end

@implementation ChooseAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择地址";
    self.view.backgroundColor = DefaultColor;
    [self setupTableView];
    [self setupFootView];
    [self loadReqData:NO];
}

- (void)setupTableView{
    self.addressTab = [[UITableView alloc]initWithFrame:CGRectZero style:
                                                       UITableViewStyleGrouped];
    self.addressTab.backgroundColor = DefaultColor;
    self.addressTab.rowHeight = UITableViewAutomaticDimension;
    self.addressTab.estimatedRowHeight = 90;
    [self.view addSubview:self.addressTab];
    [self.addressTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-48);
        make.top.equalTo(self.view).offset(0);
    }];
    if (@available(iOS 11.0, *)) {
        self.addressTab.estimatedSectionHeaderHeight = 0;
        self.addressTab.estimatedSectionFooterHeight = 0;
    }
    self.addressTab.dataSource = self;
    self.addressTab.delegate = self;
    self.addressTab.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)setupFootView{
    UIView * backView = [UIView new];
    backView.backgroundColor = DefaultColor;
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        make.height.mas_equalTo(@60);
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView).offset(10);
        make.left.equalTo(backView).offset(20);
        make.right.equalTo(backView).offset(-20);
        make.height.mas_equalTo(@40);
    }];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setImage:[UIImage imageNamed:@"icon_+"] forState:UIControlStateNormal];
    [btn setTitle:@"新增" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setLayerWithW:5.0 andColor:DefaultColor andBackW:1];
    [btn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadReqData:(BOOL)isYes{
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@AddressListPageForSelect",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"addressList"]]) {
                self.addressArray = [AddressInfo mj_objectArrayWithKeyValuesArray:
                                     response.data[@"addressList"]];
                [self.addressTab reloadData];
                if (isYes) {
                    for (AddressInfo *addInfo in self.addressArray) {
                        if (addInfo.isDefault&&self.addBack) {
                            self.addBack(addInfo);
                        }
                    }
                }
            }
        }else{
            [MBProgressHUD showError:response.message];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (void)addBtnClick{
    AddressInfo *addInfo = [AddressInfo new];
    if (self.addressArray.count<2) {
        addInfo.isDefault = YES;
    }
    [self gotoAddEditVc:addInfo];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.addressArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 90;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseAddressTableCell *chooseCell = [ChooseAddressTableCell cellWithTableView:tableView];
    AddressInfo *addInfo = self.addressArray[indexPath.section];
    chooseCell.userAddInfo = addInfo;
    chooseCell.addBack = ^(int index){
        switch (index) {
            case 1:
                [self editAdd:addInfo];
                break;
            case 2:
                [self deleteAdd:addInfo];
                break;
            default:
                break;
        }
    };
    return chooseCell;
}

- (void)editAdd:(AddressInfo *)addInfo{
    [self gotoAddEditVc:addInfo];
}

- (void)gotoAddEditVc:(AddressInfo *)addInfo{
    AddEditAddressVC *editVc = [AddEditAddressVC new];
    if (addInfo.id) {
        editVc.addId = addInfo.id;
    }
    editVc.block = ^(BOOL isSuccees) {
        if(isSuccees)
        {
            [self loadReqData:addInfo.isDefault];
        }
    };
    [self.navigationController pushViewController:editVc animated:YES];
}

- (void)deleteAdd:(AddressInfo *)addInfo{
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@deleteAddressDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"id"] = @(addInfo.id);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:response.message];
            [self loadReqData:addInfo.isDefault];
        }else{
            [MBProgressHUD showError:response.message];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressInfo *addInfo = self.addressArray[indexPath.section];
    if (self.addBack) {
        self.addBack(addInfo);
    }
    [self setDefault:addInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setDefault:(AddressInfo *)addInfo{
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@setDefaultAddressDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"id"] = @(addInfo.id);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {

        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

@end
