//
//  SearchHeadBtnView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/20.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SearchHeadBtnView.h"
#import "ScreenDetailInfo.h"
@implementation SearchHeadBtnView

- (id)initWithFrame:(CGRect)frame withArr:(NSArray *)arr{
    self = [super initWithFrame:frame];
    if (self) {
        self.tArr = arr;
        self.backgroundColor = [UIColor whiteColor];
        [self setBaseBtnWith:arr];
    }
    return self;
}

- (void)setBaseBtnWith:(NSArray *)arr{
    CGFloat space = 10;
    CGFloat curX = 15;
    CGFloat curY = 10;
    CGFloat height = 30;
    CGFloat width = 0;
    for (int i=0; i<arr.count; i++) {
        ScreenDetailInfo *dInfo = arr[i];
        UIButton *btn = [self creatBtn];
        btn.tag = i;
        if (i==0) {
            btn.enabled = NO;
        }
        if (i>0) {
            UIButton *btnL = self.subviews[i-1];
            curX = CGRectGetMaxX(btnL.frame)+space;
        }
        [btn setTitle:dInfo.title forState:UIControlStateNormal];
        
        CGRect rect = CGRectMake(0, 0, SDevWidth-30, 999);
        rect = [btn.titleLabel textRectForBounds:rect limitedToNumberOfLines:0];
        width = rect.size.width+30;
        if (width+curX>SDevWidth) {
            curY = curY+height+space;
            curX = space;
        }
        btn.frame = CGRectMake(curX, curY, width, height);
        self.height = curY+height+space;
    }
}

- (UIButton *)creatBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [btn.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_select4"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_select3"] forState:UIControlStateDisabled];
    [btn addTarget:self action:@selector(subCateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

- (void)subCateBtnAction:(UIButton *)sender{
    for (int i=0; i<self.subviews.count; i++) {
        UIButton *sBtn = self.subviews[i];
        if (i!=sender.tag) {
            sBtn.enabled = YES;
        }
    }
    sender.enabled = !sender.enabled;
    ScreenDetailInfo *dInfo = _tArr[sender.tag];
    if (self.back) {
        self.back(@(dInfo.id));
    }
}

@end
