//
//  SearchOrderView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/24.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SearchOrderView.h"
#import "SearchDateInfo.h"
@implementation SearchOrderView

- (id)initWithFrame:(CGRect)frame withDic:(NSArray *)btnArr{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatBaseView:btnArr];
    }
    return self;
}

- (void)setArr:(NSArray *)arr{
    if (arr) {
        _arr = arr;
        [self creatBaseView:_arr];
    }
}

- (void)creatBaseView:(NSArray *)arr{;
    CGFloat space = 10;
    CGFloat height = 30;
    CGFloat curX = 0;
    CGFloat width = 0;
    for (int i=0; i<arr.count; i++) {
        SearchDateInfo *info = arr[i];
        UIButton *btn = [self creatBtn];
        UIButton *btnL;
        if (i>0) {
            btnL = self.subviews[i-1];
        }
        curX = CGRectGetMaxX(btnL.frame)+space;
        btn.tag = i;
        btn.selected = info.isDefault;
        [btn setTitle:info.title forState:UIControlStateNormal];
        CGRect rect = CGRectMake(0, 0, SDevWidth-30, 999);
        rect = [btn.titleLabel textRectForBounds:rect limitedToNumberOfLines:0];
        width = rect.size.width+10;
        btn.frame = CGRectMake(curX, 15, width, height);
    }
}

- (UIButton *)creatBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[CommonUtils createImageWithColor:DefaultColor]
                   forState:UIControlStateNormal];
    [btn setBackgroundImage:[CommonUtils createImageWithColor:CUSTOM_COLOR(248, 205, 207)] forState:UIControlStateSelected];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

- (void)btnClick:(UIButton *)sender{
    for (int i=0; i<self.subviews.count; i++) {
        UIButton *sBtn = self.subviews[i];
        if (i!=(int)sender.tag) {
            sBtn.selected = NO;
        }
    }
    sender.selected = !sender.selected;
    if (self.dateBack) {
        self.dateBack(self.arr[sender.tag]);
    }
}

- (void)setAllBtnSele{
    for (UIButton *btn in self.subviews) {
        btn.selected = NO;
    }
}

@end
