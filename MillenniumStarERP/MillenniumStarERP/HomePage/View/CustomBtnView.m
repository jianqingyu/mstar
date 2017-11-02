//
//  CustomBtnView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/15.
//  Copyself © 2017年 com.millenniumStar. All selfs reserved.
//

#import "CustomBtnView.h"

@implementation CustomBtnView

+ (id)creatView{
    CustomBtnView *custom = [[CustomBtnView alloc]init];
    return custom;
}

- (id)init{
    self = [super init];
    if (self) {
        [self setBaseView];
    }
    return self;
}

- (void)setBaseView{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    self.selBtn = btn;
    UILabel *lab = [UILabel new];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:14];
    [lab setAdjustsFontSizeToFitWidth:YES];
    [self addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(btn.mas_left).with.offset(-3);
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
    self.allBtn = backBtn;
}

@end
