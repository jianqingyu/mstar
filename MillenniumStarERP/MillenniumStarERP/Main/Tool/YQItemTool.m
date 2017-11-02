//
//  YQItemTool.m
//  YQ微博
//
//  Created by tarena425 on 15/7/1.
//  Copyright (c) 2015年 ccyuqing. All rights reserved.
//

#import "YQItemTool.h"
#import "UIView+Extension.h"
@implementation YQItemTool
+ (UIBarButtonItem *)setItem:(id)target Action:(SEL)action image:(NSString *)image
                                              hightImage:(NSString *)hightImage{
    UIButton *btn = [[UIButton alloc]init];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    if (hightImage.length) {
        [btn setBackgroundImage:[UIImage imageNamed:hightImage] forState:UIControlStateHighlighted];
    }
    btn.size = CGSizeMake(20, 20);
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

+ (UIView *)setItem:(id)target Action:(SEL)action image:(NSString *)image title:(NSString *)title{
    UIView *right = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 35)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:image]
                   forState:UIControlStateNormal];
    [right addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(right).offset(0);
        make.centerX.mas_equalTo(right.mas_centerX);
        make.size.mas_equalTo(btn.currentBackgroundImage.size);
    }];
    UILabel *lab = [UILabel new];
    lab.text = title;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:12];
    [right addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_bottom).offset(0);
        make.bottom.equalTo(right).offset(0);
        make.left.equalTo(right).offset(0);
        make.right.equalTo(right).offset(0);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [right addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(right).offset(0);
        make.bottom.equalTo(right).offset(0);
        make.left.equalTo(right).offset(0);
        make.right.equalTo(right).offset(0);
    }];
    return right;
}

+ (UIView *)setBtn:(id)target Act:(SEL)action img:(NSString *)image str:(NSString *)title frame:(CGRect)frame{
    UIView *right = [[UIView alloc]initWithFrame:frame];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:image]
                   forState:UIControlStateNormal];
    [right addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(right).offset(0);
        make.centerY.mas_equalTo(right.mas_centerY);
        make.size.mas_equalTo(btn.currentBackgroundImage.size);
    }];
    
    UILabel *lab = [UILabel new];
    lab.text = title;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:12];
    [right addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(right.mas_centerY);
        make.left.equalTo(right).offset(0);
        make.right.equalTo(btn.mas_left).with.offset(-3);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [right addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(right).offset(0);
        make.bottom.equalTo(right).offset(0);
        make.left.equalTo(right).offset(0);
        make.right.equalTo(right).offset(0);
    }];
    return right;
}

@end
