//
//  RegisterViewController.m
//  CityHousekeeper
//
//  Created by yjq on 15/11/18.
//  Copyright © 2015年 com.millenniumStar. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "ChooseAddressCusView.h"
#import "PackagingTool.h"
#import "ZBButten.h"
@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *userFie;
@property (weak, nonatomic) IBOutlet UITextField *namefie;
@property (weak, nonatomic) IBOutlet UITextField *phonefie;
@property (weak, nonatomic) IBOutlet UITextField *keyfie;
@property (weak, nonatomic) IBOutlet UITextField *keyfie2;
@property (weak, nonatomic) IBOutlet UITextField *codefie;
@property (weak, nonatomic) IBOutlet ZBButten *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (nonatomic, weak) ChooseAddressCusView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *addLab;
@property (nonatomic, weak) UIView *baView;
@property (nonatomic, copy) NSString *code;
@property (nonatomic,assign) int userType;
@property (nonatomic,assign) int addId;
@property (nonatomic,assign) float addHeight;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册账号";
    self.addHeight = 270;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:
              [UIImage imageNamed:@"icon_return"] style:UIBarButtonItemStyleDone
                                       target:self action:@selector(backClick)];
    [self setBaseView];
    self.userType = 1;
}

- (void)backClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setBaseView{
    self.registerBtn.layer.cornerRadius = 5;
    self.registerBtn.layer.masksToBounds = YES;
    self.codeBtn.layer.cornerRadius = 2;
    self.codeBtn.layer.masksToBounds = YES;
    [self.codeBtn setbuttenfrontTitle:@"" backtitle:@"s后获取"];
}

//- (void)creatAddView{
//    UIView *bView = [UIView new];
//    bView.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
//    bView.hidden = YES;
//    [self.view addSubview:bView];
//    [bView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(0);
//        make.left.equalTo(self.view).offset(0);
//        make.right.equalTo(self.view).offset(0);
//        make.bottom.equalTo(self.view).offset(0);
//    }];
//    self.baView = bView;
//
//    ChooseAddressCusView *infoV = [ChooseAddressCusView createLoginView];
//    [self.view addSubview:infoV];
//    infoV.storeBack = ^(NSDictionary *store,BOOL isYes){
//        if (isYes) {
//            self.addLab.textColor = [UIColor blackColor];
//            self.addLab.text = store[@"title"];
//            self.addId = [store[@"id"]intValue];
//        }
//        [self changeAddView:YES];
//    };
//    [infoV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(0);
//        make.bottom.equalTo(self.view).offset(self.addHeight);
//        make.right.equalTo(self.view).offset(0);
//        make.height.mas_equalTo(270);
//    }];
//    self.infoView = infoV;
//}
//
//- (IBAction)didPushChooseView:(id)sender {
//    [self changeAddView:NO];
//}
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self changeAddView:YES];
//}
//
//- (void)changeAddView:(BOOL)isClose{
//    BOOL isHi = YES;
//    if (self.addHeight==270) {
//        if (isClose) {
//            return;
//        }
//        self.addHeight = 0;
//        isHi = NO;
//    }else{
//        self.addHeight = 270;
//        isHi = YES;
//    }
//    [UIView animateWithDuration:0.5 animations:^{
//        [self.infoView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.view).offset(self.addHeight);
//        }];
//        [self.infoView layoutIfNeeded];//强制绘制
//        self.baView.hidden = isHi;
//    }];
//}

- (IBAction)getCode:(UIButton *)btn{
    //发送命令
    [self requestCheckWord];
}

- (void)requestCheckWord{
    if (self.phonefie.text.length!=11) {
        [self.codeBtn resetBtn];
        SHOWALERTVIEW(@"您输入的手机号有误");
        return;
    }
    NSString *codeUrl = [NSString stringWithFormat:@"%@GetRegisterVerifyCodeDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = self.phonefie.text;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:response.message];
        }else{
            [self.codeBtn resetBtn];
            SHOWALERTVIEW(response.message);
        }
    } requestURL:codeUrl params:params];
}

- (IBAction)chooseClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.userType = sender.selected?2:1;
}

- (IBAction)nextClick:(id)sender {
    if ([self showMessage]){
        return;
    }
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@userRegisterDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = [self.userFie.text stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceCharacterSet]];
    params[@"password"] = [self.keyfie.text stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceCharacterSet]];
    params[@"trueName"] = self.namefie.text;
    params[@"phone"] = self.phonefie.text;
    params[@"phoneCode"] = self.codefie.text;
    params[@"userType"] = @(self.userType);
    params[@"memberAreaId"] = @(self.addId);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            params[@"isNoShow"] = [AccountTool account].isNoShow;
            params[@"isNorm"] = [AccountTool account].isNorm;
            params[@"isNoDriShow"] = [AccountTool account].isNoDriShow;
            Account *account = [Account accountWithDict:params];
            //自定义类型存储用NSKeyedArchiver
            [AccountTool saveAccount:account];
            [self backClick];
            [MBProgressHUD showSuccess:@"注册成功"];
        }else{
            SHOWALERTVIEW(response.message);
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (BOOL)showMessage{
    if ([PackagingTool stringContainsEmoji:self.userFie.text]) {
        SHOWALERTVIEW(@"不能输入特殊符号");
        return YES;
    }
    if (self.keyfie.text.length<6) {
        [MBProgressHUD showError:@"密码不足6位"];
        return YES;
    }
    if (![self.keyfie.text isEqualToString:self.keyfie2.text]){
        SHOWALERTVIEW(@"两次密码输入不符");
        return YES;
    }
    if (self.codefie.text.length==0) {
        SHOWALERTVIEW(@"请输入验证码");
        return YES;
    }
//    if (self.addId==0) {
//        SHOWALERTVIEW(@"请选择区域");
//        return YES;
//    }
    return NO;
}

@end
