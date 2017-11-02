//
//  CustomInvoice.m
//  MillenniumStar08.07
//
//  Created by yjq on 15/8/26.
//  Copyright (c) 2015年 qxzx.com. All rights reserved.
//

#import "CustomInvoice.h"
#import "CommonUtils.h"
@interface CustomInvoice()
{
    UIView * _logoView;//画布
    UILabel * _titleLabel;//标题
    UIButton * _headImage;//最上面的图
    UILabel * _invoiceLabel;//发票抬头
    UITextField * _message;//标题
    UIButton * _OkButton;//确定按钮
}
@end
@implementation CustomInvoice

+ (instancetype)showAlertViewCallBlock:(callBack)callBack
{
    [[self shared] setClickBlock:nil];//释放掉之前的Block
    [[self shared] setClickBlock:callBack];
    [[self shared] setHidden:NO];//设置为不隐藏
    return  [self shared];
}
//单例
+ (instancetype)shared
{
    static dispatch_once_t once = 0;
    static CustomInvoice *alert;
    dispatch_once(&once, ^{
        alert = [[CustomInvoice alloc]init];
    });
    return alert;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = (CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size};
        self.backgroundColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:0.5];
        self.windowLevel = 101;
        self.hidden = NO;
        [self controlsInit];
    }
    return self;
}
/**
 *  初始化控件
 */
- (void)controlsInit
{
    [_logoView removeFromSuperview];
    _logoView = nil;
    
    _logoView = [UIView new];
    _logoView.backgroundColor = [UIColor whiteColor];
    _logoView.layer.cornerRadius = 3;
    [self addSubview:_logoView];
    [_logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(@160);
        make.width.mas_equalTo(@240);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"确认密码";
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_logoView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_logoView.mas_centerX);
        make.top.equalTo(_logoView).offset(10);
    }];
    
    _headImage = [UIButton buttonWithType:UIButtonTypeCustom];
    _headImage.tag = 0;
    [_headImage setBackgroundImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    [_headImage addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_logoView addSubview:_headImage];
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_logoView).offset(10);
        make.centerY.mas_equalTo(_titleLabel.mas_centerY);
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(@12);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = DefaultColor;
    [_logoView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(_logoView).offset(10);
        make.right.equalTo(_logoView).offset(-10);
        make.height.mas_equalTo(@0.8);
    }];
    
    _message = [UITextField new];
    _message.borderStyle = UITextBorderStyleNone;
    _message.font = [UIFont systemFontOfSize:12];
    _message.placeholder = @"请输入账户密码";
    [_logoView addSubview:_message];
    [_message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_logoView).offset(10);
        make.right.equalTo(_logoView).offset(-10);
        make.centerY.mas_equalTo(_logoView.mas_centerY);
        make.height.mas_equalTo(@27);
    }];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = DefaultColor;
    [_logoView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_message.mas_bottom).offset(2);
        make.left.equalTo(_logoView).offset(10);
        make.right.equalTo(_logoView).offset(-10);
        make.height.mas_equalTo(@0.8);
    }];
    
    _OkButton = [self creatBtnWithTitle:@"确定" andTitleColor:[UIColor whiteColor]];
    _OkButton.layer.masksToBounds = YES;
    _OkButton.layer.cornerRadius = 2;
    [_OkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_logoView).offset(-15);
        make.right.equalTo(_logoView).offset(-10);
        make.left.equalTo(_logoView).offset(10);
        make.height.mas_equalTo(@30);
    }];
}

- (UIButton *)creatBtnWithTitle:(NSString *)title andTitleColor:(UIColor *)color{
    UIButton *btn = [[UIButton alloc]init];
    btn.tag = 1;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[CommonUtils createImageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_logoView addSubview:btn];
    return btn;
}

- (void)buttonClick:(UIButton *)sender{
    [_message resignFirstResponder];
    NSString *str ;
    if (sender.tag==0) {
        str = @"";
    }else{
        str = _message.text;
    }
    self.clickBlock(str);
    self.hidden = YES;
}

@end
