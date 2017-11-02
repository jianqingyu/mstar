//
//  PassWordViewController.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/7.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "PassWordViewController.h"
#import "YQItemTool.h"
#import "ZBButten.h"
@interface PassWordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneFie;
@property (weak, nonatomic) IBOutlet UITextField *codeFie;
@property (weak, nonatomic) IBOutlet ZBButten *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *passWord2;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic, copy) NSString *code;
@end

@implementation PassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:
      [UIImage imageNamed:@"icon_return"] style:UIBarButtonItemStyleDone target:
                                                   self action:@selector(back)];
    [self setBaseView];
}

- (void)setBaseView{
    [self.codeBtn setLayerWithW:5 andColor:BordColor andBackW:0.0001];
    [self.confirmBtn setLayerWithW:5 andColor:BordColor andBackW:0.0001];
    [self.codeBtn setbuttenfrontTitle:@"" backtitle:@"s后获取"];
}

- (void)back{
    if (self.isForgot) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)getCode:(id)sender {
    //发送命令
    [self requestCheckWord];
}

- (void)requestCheckWord{
    if (self.phoneFie.text.length!=11) {
        [self.codeBtn resetBtn];
        SHOWALERTVIEW(@"您输入的手机号有误");
        return;
    }
    NSString *codeUrl;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.isForgot) {
        params[@"phone"] = self.phoneFie.text;
        codeUrl = [NSString stringWithFormat:@"%@GetForgetPasswordVerifyCodeDo",baseUrl];
    }else{
        params[@"tokenKey"] = [AccountTool account].tokenKey;
        codeUrl = [NSString stringWithFormat:@"%@GetUserModifyPasswordVerifyCodeDo",baseUrl];
    }
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:response.message];
        }else{
            [self.codeBtn resetBtn];
            SHOWALERTVIEW(response.message);
        }
    } requestURL:codeUrl params:params];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length<6) {
        [MBProgressHUD showError:@"密码不够6位"];
    }
}

- (IBAction)confirmClick:(id)sender {
    if (self.phoneFie.text.length!=11) {
        SHOWALERTVIEW(@"您输入的手机号有误");
        return;
    }
    if (self.codeFie.text.length==0) {
        SHOWALERTVIEW(@"请输入验证码");
        return;
    }
    if (self.passWord.text.length<6){
        SHOWALERTVIEW(@"密码不足6位");
        return;
    }
    if (![self.passWord.text isEqualToString:self.passWord2.text]){
        SHOWALERTVIEW(@"两次密码输入不符");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *passUrl;
    if (self.isForgot) {
        params[@"password"] = self.passWord.text;
        params[@"phoneCode"] = self.codeFie.text;
        params[@"phone"] = self.phoneFie.text;
        passUrl = [NSString stringWithFormat:@"%@userForgetPasswordDo",baseUrl];
    }else{
        params[@"password"] = self.passWord.text;
        params[@"phoneCode"] = self.codeFie.text;
        params[@"tokenKey"] = [AccountTool account].tokenKey;
        passUrl = [NSString stringWithFormat:@"%@userModifyPasswordDo",baseUrl];
    }
    [self loadNetEditPassWithDic:params andUrl:passUrl];

}
//修改密码与忘记密码
- (void)loadNetEditPassWithDic:(NSMutableDictionary*)params andUrl:(NSString *)passUrl{
    [BaseApi getNoLogGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            params[@"userName"] = [AccountTool account].userName;
            params[@"phoneCode"] = [AccountTool account].phone;
            params[@"isNoShow"] = [AccountTool account].isNoShow;
            params[@"isNorm"] = [AccountTool account].isNorm;
            params[@"isNoDriShow"] = [AccountTool account].isNoDriShow;
            params[@"tokenKey"] = response.data[@"tokenKey"];
            Account *account = [Account accountWithDict:params];
            //自定义类型存储用NSKeyedArchiver
            [AccountTool saveAccount:account];
            [MBProgressHUD showSuccess:response.message];
            [self back];
        }else{
            SHOWALERTVIEW(response.message);
        }
        [SVProgressHUD dismiss];
    } requestURL:passUrl params:params];
}

@end
