//
//  PayViewController.m
//  MillenniumStar
//
//  Created by LanF on 15/6/16.
//  Copyright (c) 2015年 Millennium Star. All rights reserved.
//

#import "PayViewController.h"
#import "WXApi.h"
#import "PayTableCell.h"
#import "CustomInvoice.h"
#import "PayReturnPageVC.h"
#import <AlipaySDK/AlipaySDK.h>
@interface PayViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *payTable;
@property (nonatomic,   weak) UILabel *titleLab;
@property (nonatomic,   weak) UILabel *totalLab;
@property (nonatomic,   copy) NSArray *payImageArray;
@property (nonatomic,   copy) NSArray *payTitleArray;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic,   copy) NSString *message;
@property (nonatomic,   copy) NSString *appName;
@end

@implementation PayViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"支付";
    self.appName = @"MillenniumStarERP";
    [self creatTableView];
    [self initHeadAndFootView];
    [self loadHomePayData];
}

- (void)creatTableView{
    self.payImageArray = @[@"icon_pay_zfb",@"icon_pay_wx"];
    self.payTitleArray = @[@"支付宝支付",@"微信支付"];
    self.payTable = [[UITableView alloc] init];
    self.payTable.delegate = self;
    self.payTable.dataSource = self;
    [self.view addSubview:self.payTable];
    [self.payTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
}

- (void)loadHomePayData{
    NSString *str = self.isStone?@"PaymentCurrentOrderStonePage":@"PaymentCurrentOrderPage";
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,str];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = self.orderId;
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0&&[YQObjectBool boolForObject:response.data]) {
            self.titleLab.text = response.data[@"title"];
            double price = [response.data[@"needPayPrice"]doubleValue];
            self.totalLab.text = [NSString stringWithFormat:@"￥%.2f",price];
        }
    } requestURL:url params:params];
}

- (void)initHeadAndFootView{
    UIView*footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 80)];
    UIView*headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 100)];
    self.payTable.tableFooterView = footView;
    self.payTable.tableHeaderView = headView;
    
    UIView*line = [UIView new];
    [headView addSubview:line];
    line.backgroundColor = DefaultColor;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(0);
        make.right.equalTo(footView).offset(0);
        make.top.equalTo(footView).offset(0);
        make.height.mas_equalTo(@0.8);
    }];
    
    UIButton*payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [footView addSubview:payButton];
    [payButton setBackgroundImage:[CommonUtils createImageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
    [payButton setBackgroundImage:[CommonUtils createImageWithColor:CUSTOM_COLOR(191, 158, 103)] forState:UIControlStateHighlighted];
    payButton.layer.masksToBounds = YES;
    payButton.layer.cornerRadius = 5;
    [payButton setTitle:@"确认支付" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(payBtnClick:)
                                  forControlEvents:UIControlEventTouchUpInside];
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(10);
        make.right.equalTo(footView).offset(-10);
        make.top.equalTo(footView).offset(20);
        make.height.mas_equalTo(@40);
    }];
    
    UILabel*lable = [UILabel new];
    [headView addSubview:lable];
    lable.text = @"需支付金额";
    lable.textColor = [UIColor grayColor];
    lable.lineBreakMode = NSLineBreakByTruncatingMiddle;
    lable.font = [UIFont systemFontOfSize:12];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.top.equalTo(headView).offset(20);
    }];
    self.titleLab = lable;
    
    UILabel * totalPriceLabel = [UILabel new];
    [headView addSubview:totalPriceLabel];
    totalPriceLabel.text = @"￥0.00";
    totalPriceLabel.textColor = [UIColor redColor];
    totalPriceLabel.font = [UIFont systemFontOfSize:16];
    [totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.top.equalTo(lable.mas_bottom).offset(5);
    }];
    self.totalLab = totalPriceLabel;
    
    UILabel*lable2 = [UILabel new];
    [headView addSubview:lable2];
    lable2.text = @"选择支付方式";
    lable2.textColor = [UIColor darkGrayColor];
    lable2.lineBreakMode = NSLineBreakByTruncatingMiddle;
    lable2.font = [UIFont systemFontOfSize:12];
    [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(20);
        make.bottom.equalTo(headView).offset(-10);
    }];
    
    UIView*line2 = [UIView new];
    [headView addSubview:line2];
    line2.backgroundColor = DefaultColor;
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(0);
        make.right.equalTo(headView).offset(0);
        make.bottom.equalTo(headView).offset(0);
        make.height.mas_equalTo(@0.8);
    }];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.payImageArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayTableCell *tableCell = [PayTableCell cellWithTableView:tableView];
    if (indexPath.row == self.selectIndex) {
        tableCell.accessoryView = [self imageAccessoryView];
    }else{
        tableCell.accessoryView = nil;
    }
    tableCell.logImage.image = [UIImage imageNamed:[self.payImageArray objectAtIndex:indexPath.row]];
    tableCell.payName.text = [self.payTitleArray objectAtIndex:indexPath.row];
    tableCell.textLabel.font = [UIFont systemFontOfSize:14];
    return tableCell;
}

- (UIImageView *)imageAccessoryView{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    imageView.image = [UIImage imageNamed:@"icon_lisel"];
    return imageView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectIndex = indexPath.row;
    [self.payTable reloadData];
}
//支付按钮
- (void)payBtnClick:(UIButton*)button{
    if (self.selectIndex == 0) {
        [self alipayMent];
    }else if(self.selectIndex == 1){
        [MBProgressHUD showSuccess:@"功能暂未开放"];
//        if ([WXApi isWXAppInstalled]) {
//            [self wechatPay];
//        } else {
//            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"温馨提醒" message:@"您的手机没有安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
    }
}
//支付宝支付
- (void)alipayMent{
    [SVProgressHUD show];
    App;
    app.aliPayCallBack = ^(BOOL isSuccees) {
        if(isSuccees){
            [self openReturnPageVc];
        }
    };
    NSString *url = ZFBPay;
    if (self.isStone) {
        url = ZFBStonePay;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = self.orderId;
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0&&[YQObjectBool boolForObject:response.data]) {
            NSString *strUrl = response.data;
            NSString *orderString = [strUrl stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
            [self openAliPayWith:orderString];
        }else{
            [MBProgressHUD showError:response.message];
        }
    } requestURL:url params:params];
}

- (void)openAliPayWith:(NSString *)order{
    [[AlipaySDK defaultService] payOrder:order fromScheme:self.appName callback:^(NSDictionary *resultDic) {
        NSInteger orderState = [resultDic[@"resultStatus"]integerValue];
        if (orderState==9000) {
            [MBProgressHUD showSuccess:@"支付成功"];
            [self openReturnPageVc];
            return ;
        }else{
            NSString *returnStr;
            switch (orderState) {
                case 8000:
                    returnStr = @"订单正在处理中";
                    break;
                case 4000:
                    returnStr = @"订单支付失败";
                    break;
                case 6001:
                    returnStr = @"订单取消";
                    break;
                case 6002:
                    returnStr = @"网络连接出错";
                    break;
                default:
                    break;
            }
            [MBProgressHUD showError:returnStr];
        }
    }];
}
//打开支付成功页面
- (void)openReturnPageVc{
    PayReturnPageVC *pageVc = [PayReturnPageVC new];
    [self.navigationController pushViewController:pageVc animated:YES];
}
//微信支付
- (void)wechatPay{
    [SVProgressHUD show];
    App;
    app.weChatPayBlock = ^(BOOL isSuccees){
        if(isSuccees){
            [self openReturnPageVc];
        }
    };
    NSString *url = WXPay;
    if (self.isStone) {
        url = WXStonePay;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"orderId"] = self.orderId;
    dic[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        [SVProgressHUD dismiss];
        if([response.error intValue]==0){
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.openID              = response.data[@"appid"];
                req.partnerId           = response.data[@"partnerid"];
                req.prepayId            = response.data[@"prepayid"];
                req.nonceStr            = response.data[@"noncestr"];
                req.timeStamp           = [response.data[@"timestamp"]intValue];
                req.package             = @"Sign=WXPay";
                req.sign                = response.data[@"sign"];
            [WXApi sendReq:req];
        }
    } requestURL:url params:dic];
}

@end
