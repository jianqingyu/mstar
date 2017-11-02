//
//  BaseCusLoginView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/12/8.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "BaseCusLoginView.h"

@implementation BaseCusLoginView

+ (BaseCusLoginView *)createLoginView{
    static BaseCusLoginView *_loginView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _loginView = [[BaseCusLoginView alloc]init];
    });
    return _loginView;
}

- (id)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SDevWidth, SDevHeight);
        [self setupBaseView];
    }
    return self;
}

- (void)setupBaseView{
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logBgView"]];
    [self addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(SDevWidth*1.2);
    }];
    UIView *backV = [[UIView alloc]init];
    backV.backgroundColor = [UIColor blackColor];
    [self addSubview:backV];
    [backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(SDevWidth*0.8);
        make.bottom.equalTo(self).offset(0);
    }];
    self.backView = backV;
}

- (void)setBaseLines:(UIView *)supV andTop:(UIView *)topView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor blackColor];
    [self.backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(10);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(@1);
    }];
}

- (void)setImage:(UIView *)supV andFie:(UIView *)topView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor blackColor];
    [self.backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(10);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(@1);
    }];
}

- (void)setBottomView{
    UIButton *btn = [self setBottomBtnWithTitle:@"注册新账号"];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backView).offset(-20);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(@40);
    }];
    self.regisBtn = btn;
    UIButton *btn2 = [self setBottomBtnWithTitle:@"忘记密码"];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backView).offset(-20);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(@40);
    }];
    self.editPassBtn = btn2;
}

- (UIButton *)setBottomBtnWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.backView addSubview:btn];
    return btn;
}

@end
