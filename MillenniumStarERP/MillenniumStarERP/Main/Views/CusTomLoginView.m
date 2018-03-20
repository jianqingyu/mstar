//
//  CusTomLoginView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/11/3.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "CusTomLoginView.h"
#import "ZBButten.h"
#import "SaveDataTool.h"
#import "JPUSHService.h"
#import "NetworkDetermineTool.h"
@interface CusTomLoginView()<UITextFieldDelegate>
@property (weak, nonatomic) UITextField *codeField;
@property (weak, nonatomic) UIView *loginView;
@property (weak, nonatomic) UIButton *loginBtn;
@property (weak, nonatomic) ZBButten *getCodeBtn;
@property (weak, nonatomic) UIImageView *backImg;
@property (weak, nonatomic) UIView *logView;
@property (copy, nonatomic) NSString *code;
@property (copy, nonatomic) NSString *verson;
@end

@implementation CusTomLoginView

+ (CusTomLoginView *)createLoginView{
    static CusTomLoginView *_loginView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _loginView = [[CusTomLoginView alloc]init];
    });
    return _loginView;
}

- (id)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self creatBaseView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (SDevWidth>SDevHeight) {
        [self.backImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(0);
        }];
        CGFloat mar = 10;
        if (SDevHeight>320) {
            mar = SDevHeight*0.1;
        }
        if (!IsPhone) {
            mar = SDevHeight*0.3;
        }
        [self.logView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(mar);
        }];
    }else{
        [self.backImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(SDevWidth*5/6-SDevHeight);
        }];
        CGFloat mar = SDevHeight*0.3;
        if (!IsPhone) {
            mar = SDevHeight*0.5;
        }
        [self.logView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(mar);
        }];
    }
}

- (void)creatBaseView{
    CGFloat loWid = MIN(SDevWidth, SDevHeight)*0.7;
    if (!IsPhone) {
        loWid = MIN(SDevWidth, SDevHeight)*0.4;
    }
    UIImageView *imageB = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"backView"]];
    [self addSubview:imageB];
    [imageB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(SDevWidth*5/6-SDevHeight);  
    }];
    self.backImg = imageB;
    
    UILabel *lab = [UILabel new];
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:14];
    lab.text = appVer;
    [self addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.left.equalTo(self).offset(15);
    }];
    
    //底部登录页面
    UIView *loginV = [[UIView alloc]init];
    loginV.backgroundColor = [UIColor clearColor];
    [self addSubview:loginV];
    [loginV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(SDevHeight*0.5);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.equalTo(self).offset(0);
        make.width.mas_equalTo(loWid);
    }];
    self.logView = loginV;
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo2"]];
    [loginV addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginV).offset(0);
        make.centerX.mas_equalTo(loginV.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80, 103));
    }];
    imageV.hidden = YES;
    
    [self creatListView:loginV isC:1];
    [self creatListView:loginV isC:2];
    UIView *listView3 = [self creatListView:loginV isC:3];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登  陆" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick:)
                               forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setLayerWithW:3 andColor:BordColor andBackW:0.001];
    [loginV addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listView3.mas_bottom).with.offset(15);
        make.left.equalTo(loginV).offset(0);
        make.right.equalTo(loginV).offset(0);
        make.height.mas_equalTo(@35);
    }];
    
    UIButton *restBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    restBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [restBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    [restBtn addTarget:self action:@selector(resetClick:)
       forControlEvents:UIControlEventTouchUpInside];
    [loginV addSubview:restBtn];
    [restBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).with.offset(3);
        make.left.equalTo(loginV).offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    UIButton *eidtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    eidtBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [eidtBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [eidtBtn addTarget:self action:@selector(editClick:)
      forControlEvents:UIControlEventTouchUpInside];
    [loginV addSubview:eidtBtn];
    [eidtBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).with.offset(3);
        make.right.equalTo(loginV).offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    NSString *name = [AccountTool account].userName;
    NSString *password = [AccountTool account].password;
    _nameFie.text = name;
    _passWordFie.text = password;
}

- (UIView *)creatListView:(UIView *)loginV isC:(int)staue{
    CGFloat heightMar = 5;
    CGFloat fieH = 20;
    CGFloat viewH = (staue-1)*(1.6+39)+110;
    UIView *view = [[UIView alloc]init];
    [loginV addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginV).offset(viewH);
        make.left.equalTo(loginV).offset(0);
        make.right.equalTo(loginV).offset(0);
        make.height.mas_equalTo((fieH+heightMar+1.6));
    }];

    UIView *line1 = [self creatLineChange:view];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(0);
        make.left.equalTo(view).offset(0);
        make.right.equalTo(view).offset(0);
        make.height.mas_equalTo(@0.8);
    }];
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_user"]];
    [view addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).with.offset(heightMar);
        make.left.equalTo(view).offset(0);
        make.size.mas_equalTo(CGSizeMake(fieH, fieH));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor whiteColor];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).with.offset(heightMar+2);
        make.left.equalTo(image.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(0.5, fieH-4));
    }];
    
    UITextField *fie = [[UITextField alloc]init];
    fie.textColor = [UIColor whiteColor];
    fie.font = [UIFont systemFontOfSize:12];
    [view addSubview:fie];
    [fie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).with.offset(heightMar);
        make.left.equalTo(line.mas_right).with.offset(5);
        make.right.equalTo(view).offset(0);
        make.height.mas_equalTo(fieH);
    }];
    switch (staue) {
        case 1:
            fie.placeholder = @"用户名/手机号码";
            self.nameFie = fie;
            break;
        case 2:
            fie.placeholder = @"请输入密码";
            self.passWordFie = fie;
            fie.secureTextEntry = YES;
            image.image = [UIImage imageNamed:@"icon_pass"];
            break;
        default:{
            fie.placeholder = @"请输入验证码";
            image.image = [UIImage imageNamed:@"icon_code"];
            fie.keyboardType = UIKeyboardTypeNumberPad;
            fie.delegate = self;
            self.codeField = fie;
            
            ZBButten *btn = [ZBButten buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor lightGrayColor];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setLayerWithW:8 andColor:BordColor andBackW:0.0001];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [btn setbuttenfrontTitle:@"" backtitle:@"s后获取"];
            [btn addTarget:self action:@selector(getCode:)
                                  forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(line1.mas_bottom).with.offset(heightMar);
                make.right.equalTo(view).offset(0);
                make.size.mas_equalTo(CGSizeMake(80, fieH));
            }];
            self.getCodeBtn = btn;
        }
            break;
    }
    [fie setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    UIView *line2 = [self creatLineChange:view];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fie.mas_bottom).with.offset(heightMar);
        make.left.equalTo(view).offset(0);
        make.right.equalTo(view).offset(0);
        make.height.mas_equalTo(@0.8);
    }];
    return fie;
}

- (UIView *)creatLineChange:(UIView *)view{
    CGFloat loWid = MIN(SDevWidth, SDevHeight)*0.7;
    if (!IsPhone) {
        loWid = MIN(SDevWidth, SDevHeight)*0.4;
    }
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor clearColor];
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                     (__bridge id)[UIColor lightGrayColor].CGColor,
                     (__bridge id)[UIColor clearColor].CGColor];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 0);
    layer.frame = (CGRect){CGPointZero, CGSizeMake(loWid, 0.8)};
    [line.layer addSublayer:layer];
    [view addSubview:line];
    return line;
}

- (void)getCode:(ZBButten *)btn {
    [self resignViewResponder];
    [self requestCheckWord];
}

- (void)requestCheckWord{
    if (self.nameFie.text.length==0||self.passWordFie.text==0){
        [self.getCodeBtn resetBtn];
        [NewUIAlertTool show:@"请输入用户名和密码" okBack:nil andView:self yes:NO];
        return;
    }
    NSString *codeUrl = [NSString stringWithFormat:@"%@GetLoginVerifyCodeDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = self.nameFie.text;
    params[@"password"] = self.passWordFie.text;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showMessage:response.message];
        }else{
            [self.getCodeBtn resetBtn];
            [NewUIAlertTool show:response.message okBack:nil andView:self yes:NO];
        }
    } requestURL:codeUrl params:params];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignViewResponder];
}

- (void)resignViewResponder{
    [self.nameFie resignFirstResponder];
    [self.codeField resignFirstResponder];
    [self.passWordFie resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self loginHome];
    return YES;
}

- (void)loginClick:(UIButton *)sender {
    sender.enabled = NO;
    [self loginHome];
    sender.enabled = YES;
}
//登录login
- (void)loginHome{
    if (self.codeField.text.length==0){
        [MBProgressHUD showMessage:@"请输入验证码"];
        return;
    }
    if (![NetworkDetermineTool isExistenceNet]) {
        [MBProgressHUD showMessage:@"没有网络"];
        return;
    }
    [SVProgressHUD show];
    [self resignViewResponder];
    NSString *reId = [JPUSHService registrationID];
    if (reId.length==0) {
        reId = [JPUSHService registrationID];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = self.nameFie.text;
    params[@"password"] = self.passWordFie.text;
    params[@"phoneCode"] = self.codeField.text;
    params[@"jRegid"] = reId;
    params[@"system"] = @"iOS";
    NSString *logUrl = [NSString stringWithFormat:@"%@userLoginDo",baseUrl];
    [BaseApi getNoGeneralData:^(BaseResponse *response, NSError *error) {
        if (response !=nil&&[response.error intValue]==0) {
            params[@"tokenKey"] = response.data[@"tokenKey"];
            params[@"isNoShow"] = [AccountTool account].isNoShow;
            params[@"isNoDriShow"] = [AccountTool account].isNoDriShow;
            params[@"isNorm"] = [AccountTool account].isNorm;
            Account *account = [Account accountWithDict:params];
            //自定义类型存储用NSKeyedArchiver
            [AccountTool saveAccount:account];
            self.codeField.text = @"";
            if (self.btnBack) {
                self.btnBack(1);
            }
        }else{
            NSString *str = response.message?response.message:@"登录失败";
            SHOWALERTVIEW(str);
        }
    } requestURL:logUrl params:params];
}

- (void)resetClick:(id)sender{
    [self resignViewResponder];
    if (self.btnBack) {
        self.btnBack(2);
    }
}

- (void)editClick:(id)sender{
    [self resignViewResponder];
    if (self.btnBack) {
        self.btnBack(3);
    }
}

@end
