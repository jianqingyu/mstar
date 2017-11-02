//
//  CustomTopBtn.m
//  MillenniumStarERP
//
//  Created by yjq on 17/7/26.
//  Copyself © 2017年 com.millenniumStar. All selfs reserved.
//

#import "CustomTopBtn.h"

@implementation CustomTopBtn

+ (CustomTopBtn *)creatCustomView{
    CustomTopBtn *editView = [[CustomTopBtn alloc]init];
    return editView;
}

- (id)init{
    self = [super init];
    if (self) {
        [self setCustomTopBtn];
    }
    return self;
}

- (void)setCustomTopBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    self.sBtn = btn;
    
    UILabel *lab = [UILabel new];
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:12];
    [self addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_bottom).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
    }];
    self.titleLab = lab;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
    }];
    self.bBtn = backBtn;
}

@end
