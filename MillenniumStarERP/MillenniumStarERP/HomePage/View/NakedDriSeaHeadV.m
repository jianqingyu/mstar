//
//  NakedDriSeaHeadV.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriSeaHeadV.h"
#import "CustomShapeBtn.h"
@interface NakedDriSeaHeadV()
@property (nonatomic,weak)UIButton *imgBtn;
@property (nonatomic,weak)UIButton *priceBtn;
@end
@implementation NakedDriSeaHeadV

- (void)setTopArr:(NSArray *)topArr{
    if (topArr) {
        _topArr = topArr;
        NSInteger total = _topArr.count;
        CGFloat rowWid = 80;
        CGFloat rowhei = 30;
        for (int i=0; i<total+1; i++) {
            UIButton *btn = [self creatBtn];
            btn.frame = CGRectMake(rowWid*i,0, rowWid, rowhei);
            if (i==1) {
                UIButton *img = [UIButton buttonWithType:UIButtonTypeCustom];
                img.frame = CGRectMake(rowWid-20, 0, 20, 30);
                [img setImage:[UIImage imageNamed:@"icon_sort"] forState:UIControlStateNormal];
                [img addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn addSubview:img];
                self.imgBtn = img;
            }
            if (i==2&&[[AccountTool account].isNoShow intValue]==0) {
                UIButton *img = [UIButton buttonWithType:UIButtonTypeCustom];
                img.frame = CGRectMake(rowWid-20, 0, 20, 30);
                [img setImage:[UIImage imageNamed:@"icon_sort"] forState:UIControlStateNormal];
                [img addTarget:self action:@selector(priceClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn addTarget:self action:@selector(priceClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn addSubview:img];
                self.priceBtn = img;
            }
            if (i==total-1) {
                btn.width = rowWid+40;
            }
            if (i==total) {
                btn.x = rowWid*i+40;
                [btn setTitle:@"" forState:UIControlStateNormal];
                break;
            }
            [btn setTitle:_topArr[i] forState:UIControlStateNormal];
        }
    }
}

- (UIButton *)creatBtn{
    CustomShapeBtn *btn = [CustomShapeBtn buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [btn.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self addSubview:btn];
    return btn;
}

- (void)sortClick:(id)sender{
    [self.priceBtn setImage:[UIImage imageNamed:@"icon_sort"] forState:UIControlStateNormal];
    NSString *imgName;
    if ([_string isEqualToString:@"weight_desc"]) {
        _string = @"";
        imgName = @"icon_sort";
    }else if ([_string isEqualToString:@"weight_asc"]){
        _string = @"weight_desc";
        imgName = @"icon_sort_d";
    }else{
        _string = @"weight_asc";
        imgName = @"icon_sort_u";
    }
    [self.imgBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    if (self.back) {
        self.back(_string);
    }
}

- (void)priceClick:(id)sender{
    [self.imgBtn setImage:[UIImage imageNamed:@"icon_sort"] forState:UIControlStateNormal];
    NSString *imgName;
    if ([_string isEqualToString:@"price_desc"]) {
        _string = @"";
        imgName = @"icon_sort";
        
    }else if ([_string isEqualToString:@"price_asc"]){
        _string = @"price_desc";
        imgName = @"icon_sort_d";
    }else{
        _string = @"price_asc";
        imgName = @"icon_sort_u";
    }
    [self.priceBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    if (self.back) {
        self.back(_string);
    }
}

@end
