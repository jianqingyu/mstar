//
//  FinishedListView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/26.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "FinishedListView.h"

@implementation FinishedListView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect l1Frame = CGRectMake(0, 0, frame.size.width/2, frame.size.height);
        UILabel *l1 = [[UILabel alloc]initWithFrame:l1Frame];
        l1.font = [UIFont systemFontOfSize:12];
        l1.textColor = [UIColor darkGrayColor];
        [self addSubview:l1];
        self.lab1 = l1;
        
        CGRect l2Frame = CGRectMake(l1.width,0,l1.width,l1.height);
        UILabel *l2 = [[UILabel alloc]initWithFrame:l2Frame];
        l2.font = [UIFont systemFontOfSize:12];
        l2.textColor = [UIColor darkGrayColor];
        [self addSubview:l2];
        self.lab2 = l2;
    }
    return self;
}

@end
