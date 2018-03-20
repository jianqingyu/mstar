//
//  ChangeUserInfoVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/8/14.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "ChangeUserInfoVC.h"
#import "AddressInfo.h"
#import "CustomerInfo.h"
#import "StrWithIntTool.h"
#import "DetailTypeInfo.h"
#import "ChooseAddressVC.h"
#import "SearchCustomerVC.h"
#import "NakedDriConfirmHeadV.h"
@interface ChangeUserInfoVC ()<NakedDriConfirmHeadVDelegate>
@property (weak, nonatomic) IBOutlet UIButton *conBtn;
@property (weak, nonatomic) NakedDriConfirmHeadV *headView;
@property (nonatomic,strong)CustomerInfo *cusInfo;
@property (nonatomic,strong)AddressInfo *addressInfo;
@property (nonatomic,assign)BOOL isSelBtn;
@end

@implementation ChangeUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择客户信息";
    self.view.backgroundColor = DefaultColor;
    [self setupTableHeadView];
    [self loadAddressDataInfo];
}

//加载默认地址
- (void)loadAddressDataInfo{
    NSString *url = [NSString stringWithFormat:@"%@InitDataForQxzx",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"address"]]){
                self.addressInfo = [AddressInfo mj_objectWithKeyValues:
                                    response.data[@"address"]];
            }
            if ([YQObjectBool boolForObject:response.data[@"DefaultCustomer"]]){
                self.cusInfo = [CustomerInfo mj_objectWithKeyValues:
                                response.data[@"DefaultCustomer"]];
            }
        }
    } requestURL:url params:params];
}

- (void)setupTableHeadView{
    [self.conBtn setLayerWithW:3 andColor:BordColor andBackW:0.0001];
    NakedDriConfirmHeadV *headV = [[NakedDriConfirmHeadV alloc]initWithFrame:CGRectZero];
    headV.bottomV.hidden = YES;
    headV.noteView.hidden = YES;
    headV.delegate = self;
    [self.view addSubview:headV];
    [headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(@(128));
    }];
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
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data]) {
                if ([response.data[@"state"]intValue]==0) {
                    SHOWALERTVIEW(@"没有此客户记录");
                    self.cusInfo.customerID = 0;
                }else if([response.data[@"state"]intValue]==1){
                    self.cusInfo = [CustomerInfo objectWithKeyValues:response.data[@"customer"]];
                }else if ([response.data[@"state"]intValue]==2){
                    [self pushSearchVC];
                }
            }
        }else{
            [MBProgressHUD showError:response.message];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (IBAction)sureClick:(id)sender {
    if (!self.addressInfo) {
        [MBProgressHUD showError:@"请选择地址"];
        return;
    }
    if (!self.cusInfo) {
        [MBProgressHUD showError:@"请选择客户"];
        return;
    }
    StorageDataTool *data = [StorageDataTool shared];
    data.cusInfo = self.cusInfo;
    data.addInfo = self.addressInfo;
    NSDictionary *dic = @{@"add":self.addressInfo,@"cus":self.cusInfo};
    if (self.back) {
        self.back(dic);
    }
}

@end
