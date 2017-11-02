//
//  CustomInputPassView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/8/4.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "CustomInputPassView.h"
@interface CustomInputPassView()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *message;
@end
@implementation CustomInputPassView

- (id)init{
    self = [super init];
    self.backgroundColor = CUSTOM_COLOR_ALPHA(88, 88, 88, 0.5);
    if (self) {
        [self controlsInit];
    }
    return self;
}

- (void)controlsInit
{
   UIView *_logoView = [UIView new];
    _logoView.backgroundColor = [UIColor whiteColor];
    _logoView.layer.cornerRadius = 3;
    [self addSubview:_logoView];
    [_logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(@160);
        make.width.mas_equalTo(@240);
    }];
    
    UILabel *_titleLabel = [UILabel new];
    _titleLabel.text = @"请输入密码";
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_logoView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_logoView.mas_centerX);
        make.top.equalTo(_logoView).offset(10);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = DefaultColor;
    [_logoView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(_logoView).offset(15);
        make.right.equalTo(_logoView).offset(-15);
        make.height.mas_equalTo(@0.8);
    }];
    
    _message = [UITextField new];
    _message.delegate = self;
    _message.borderStyle = UITextBorderStyleNone;
    _message.secureTextEntry = YES;
    _message.font = [UIFont systemFontOfSize:14];
    _message.placeholder = @"请输入账户密码";
    [_logoView addSubview:_message];
    [_message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_logoView).offset(15);
        make.right.equalTo(_logoView).offset(-15);
        make.centerY.mas_equalTo(_logoView.mas_centerY);
        make.height.mas_equalTo(@27);
    }];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = DefaultColor;
    [_logoView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_message.mas_bottom).offset(2);
        make.left.equalTo(_logoView).offset(15);
        make.right.equalTo(_logoView).offset(-15);
        make.height.mas_equalTo(@0.8);
    }];
    
    UIButton *_OkButton = [self creatBtnWithTitle:@"确定" andTitleColor:[UIColor whiteColor]];
    _OkButton.layer.masksToBounds = YES;
    _OkButton.layer.cornerRadius = 2;
    [_logoView addSubview:_OkButton];
    [_OkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_logoView).offset(-15);
        make.right.equalTo(_logoView).offset(-15);
        make.left.equalTo(_logoView).offset(15);
        make.height.mas_equalTo(@35);
    }];
}

- (UIButton *)creatBtnWithTitle:(NSString *)title andTitleColor:(UIColor *)color{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[CommonUtils createImageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)buttonClick:(UIButton *)sender{
    [_message resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_message resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    BOOL isYes = [textField.text isEqualToString:[AccountTool account].password];
    self.clickBlock(isYes);
    textField.text = @"";
}

@end
