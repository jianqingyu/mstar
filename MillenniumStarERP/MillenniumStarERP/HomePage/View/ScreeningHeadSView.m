//
//  ScreeningHeadSView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/22.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ScreeningHeadSView.h"
@interface ScreeningHeadSView()
@property (nonatomic,weak)UIButton *imgBtn;
@end
@implementation ScreeningHeadSView
- (id)initWithFrame:(CGRect)frame WithIdx:(NSInteger)section andTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIButton *openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        openButton.tag = section;
        openButton.frame = CGRectMake(0, 0, SDevWidth-20, 40);
        [openButton addTarget:self action:@selector(openClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:openButton];
        
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [imageButton setBackgroundImage:[UIImage imageNamed:@"icon_down"] forState:UIControlStateNormal];
        [imageButton setBackgroundImage:[UIImage imageNamed:@"icon_right2"] forState:UIControlStateSelected];
        [self addSubview:imageButton];
        [imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        self.imgBtn = imageButton;
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth-20, 0.5)];
        line.backgroundColor = DefaultColor;
        [self addSubview:line];
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.text = title;
        titleLab.backgroundColor = MAIN_COLOR;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont systemFontOfSize:14];
        [titleLab setLayerWithW:3 andColor:MAIN_COLOR andBackW:0.8];
        [self addSubview:titleLab];
        CGRect rect = CGRectMake(0, 0, DevWidth-20, 999);
        rect = [titleLab textRectForBounds:rect limitedToNumberOfLines:0];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_offset(@25);
            make.width.mas_offset(@(rect.size.width+30));
        }];
    }
    return self;
}

- (void)openClick:(UIButton *)btn{
    _imgBtn.selected = !_imgBtn.selected;
    if (_didScreenWithIndex) {
        self.didScreenWithIndex(btn.tag);
    }
}

@end
