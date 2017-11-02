//
//  AllListHeadView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/10/10.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "AllListHeadView.h"

@implementation AllListHeadView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIButton *heBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        heBtn.frame = CGRectMake(20, 5, 100, 30);
        [heBtn setTitle:@"筛选条件" forState:UIControlStateNormal];
        heBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [heBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [heBtn setBackgroundColor:DefaultColor];
        
        UIButton *log = [UIButton buttonWithType:UIButtonTypeCustom];
        log.frame = CGRectMake(100, 15, 10, 10);
        [log setImage:[UIImage imageNamed:@"icon_right_red"] forState:UIControlStateNormal];
        [log setImage:[UIImage imageNamed:@"icon_down_red"] forState:UIControlStateSelected];
        
        [self addSubview:heBtn];
        [self addSubview:log];
        self.tBtn = heBtn;
        self.lBtn = log;
    }
    return self;
}

@end
