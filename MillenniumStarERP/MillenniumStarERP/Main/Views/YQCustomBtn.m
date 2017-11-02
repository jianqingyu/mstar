//
//  YQCustomBtn.m
//  MillenniumStarERP
//
//  Created by yjq on 16/12/2.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "YQCustomBtn.h"
@interface YQCustomBtn()
@property (nonatomic,weak)UIView *backView;
@property (nonatomic,weak)UILabel *strLab;
@property (nonatomic,weak)UIButton *sBtn;
@end
@implementation YQCustomBtn

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBaseLabAndBtn];
        [self setupBack];
    }
    return self;
}

- (void)setupBack{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backCLick:)
      forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
    }];
}

- (void)backCLick:(id)sender{
    self.sBtn.selected = !self.sBtn.selected;
    if (self.clickBlock) {
        self.clickBlock(YES);
    }
}

- (void)setupBaseLabAndBtn{
    UIView *right = [[UIView alloc]init];
    [self addSubview:right];
    self.backView = right;
    
    UILabel *lab = [UILabel new];
    lab.numberOfLines = 0;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:12];
    [right addSubview:lab];
    self.strLab = lab;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [right addSubview:btn];
    self.sBtn = btn;
}

- (void)setupBtnWithStr:(NSString *)str andIm:(NSString *)img
                 andSIm:(NSString *)sImg{
    self.strLab.text = str;
    CGRect rect = CGRectMake(0, 0, self.width-20, self.height);
    rect = [self.strLab textRectForBounds:rect limitedToNumberOfLines:0];
    self.strLab.size = rect.size;
    self.strLab.x = 0;
    
    [self.sBtn setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [self.sBtn setBackgroundImage:[UIImage imageNamed:sImg] forState:UIControlStateSelected];
    CGSize bSize = self.sBtn.currentBackgroundImage.size;
    CGFloat cenY = MAX(rect.size.height, bSize.height);
    self.strLab.centerY = cenY/2;
    
    self.sBtn.size = bSize;
    self.sBtn.x = rect.size.width;
    self.sBtn.centerY = cenY/2;
    
    CGSize viewS = CGSizeMake(rect.size.width+bSize.width,cenY);
    self.backView.size = viewS;
    self.backView.center = CGPointMake(self.width/2, self.height/2);
}

@end
