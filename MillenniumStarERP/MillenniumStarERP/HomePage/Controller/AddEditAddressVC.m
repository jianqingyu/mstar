//
//  AddEditAddressVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/28.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "AddEditAddressVC.h"
#import "AddressTableVC.h"
#import "AddressInfo.h"
@interface AddEditAddressVC ()
{
    int cityid,citysubid ,proID;
}
@property (weak, nonatomic) IBOutlet UITextField *nameFie;
@property (weak, nonatomic) IBOutlet UITextField *phoneFie;
@property (weak, nonatomic) IBOutlet UILabel *addLab;
@property (weak, nonatomic) IBOutlet UITextField *detailFie;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic,strong)AddressInfo *info;
@end

@implementation AddEditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改地址";
    self.confirmBtn.layer.cornerRadius = 5;
    self.confirmBtn.layer.masksToBounds = YES;
    if (self.addId) {
        [self loadAddress];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeAddressText:) name:NotificationName object:nil];
}

- (void)loadAddress{
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@userModifyAddressPage",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"id"] = @(self.addId);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"address"]]) {
                self.info = [AddressInfo objectWithKeyValues:response.data[@"address"]];
                [self setupBaseData];
            }
        }else{
            [MBProgressHUD showError:response.message];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (void)setupBaseData{
    self.nameFie.text = self.info.name;
    self.phoneFie.text = self.info.phone;
    self.addLab.text = self.info.place;
    self.detailFie.text = self.info.addr;
    cityid = self.info.city_id;
    citysubid = self.info.area_id;
    proID = self.info.province_id;
}

//显示地址
- (void)changeAddressText:(NSNotification *)notification{
    NSMutableArray *address = notification.userInfo[UserInfoName];
    self.addLab.text = address[0];
    cityid = [address[2] intValue];
    citysubid = [address[3] intValue];
    proID = [address[1] intValue];
}

- (NSMutableDictionary *)editAddress{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"name"] = self.nameFie.text;
    params[@"phone"] = self.phoneFie.text;
    params[@"addr"] = self.detailFie.text;
    params[@"provinceId"] = @(proID);
    params[@"cityId"] = @(cityid);
    params[@"areaId"] = @(citysubid);
    params[@"id"] = @(self.addId);
    return params;
}

- (NSMutableDictionary *)createAddress{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"name"] = self.nameFie.text;
    params[@"phone"] = self.phoneFie.text;
    params[@"addr"] = self.detailFie.text;
    params[@"provinceId"] = @(proID);
    params[@"cityId"] = @(cityid);
    params[@"areaId"] = @(citysubid);
    return params;
}

- (IBAction)chooseAdd:(id)sender {
    AddressTableVC *chooseAdd = [AddressTableVC new];
    [self.navigationController pushViewController:chooseAdd animated:YES];
}

- (IBAction)confirmClick:(id)sender {
    if (!proID) {
        [MBProgressHUD showSuccess:@"请选择地址"];
        return;
    }
    NSMutableDictionary *params;
    NSString *url;
    if (_addId) {
        params = [self editAddress];
        url = [NSString stringWithFormat:@"%@modifyAddressDo",baseUrl];
    }else{
        params = [self createAddress];
        url = [NSString stringWithFormat:@"%@addUserAddressDo",baseUrl];
    }
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error integerValue]==0)
        {
            [MBProgressHUD showSuccess:@"提交成功"];
            if (self.block) {
                self.block(YES);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:response.message];
        }
    } requestURL:url params:params];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
