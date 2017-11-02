//
//  ScreeningTopView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/16.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "ScreeningTopView.h"
#import "WeightInfo.h"
#import "ScreeningInfo.h"
#import "ScreenDetailInfo.h"
@interface ScreeningTopView ()
@property (nonatomic,assign)int count;
@property (nonatomic,strong)NSMutableArray *mutA;
@property (nonatomic,strong)NSMutableArray *mutB;
@end
@implementation ScreeningTopView

- (id)init{
    self = [super init];
    if (self) {
        self.backgroundColor = DefaultColor;
        self.mutA = @[].mutableCopy;
        self.mutB = @[].mutableCopy;
        UILabel *lab = [[UILabel alloc]init];
        lab.text = @"已选条件";
        lab.textColor = [UIColor redColor];
        lab.font = [UIFont systemFontOfSize:15];
        [self addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(5);
        }];
    }
    return self;
}

- (void)setGoods:(NSArray *)goods{
    if (goods) {
        _goods = goods;
        self.count = 0;
        [self.mutA removeAllObjects];
        for (ScreeningInfo *info in _goods) {
            for (ScreenDetailInfo *dInfo in info.attributeList) {
                if (dInfo.isSelect&&info.mulSelect) {
                    [self.mutA addObject:dInfo];
                    self.count++;
                }
            }
        }
        for (WeightInfo *wInfo in self.values) {
            if (wInfo.txt.length>0) {
                [self.mutA addObject:wInfo];
            }
        }
        for (UIButton *btn in _mutB) {
            [btn removeFromSuperview];
        }
        CGFloat height = 20+ 2*HROWSPACE;
        for (int i=0; i<self.mutA.count; i++) {
            int column = i % HCOLUMN;
            int row = i / HCOLUMN;
            UIButton *btn;
            NSString *title;
            if (i<self.count) {
                ScreenDetailInfo *dInfo = self.mutA[i];
                btn = [self creatBtn:@selector(subCateBtn:)];
                title = [NSString stringWithFormat:@"x %@",dInfo.title];
            }else{
                WeightInfo *info = self.mutA[i];
                btn = [self creatBtn:@selector(subValueBtn:)];
                title = [NSString stringWithFormat:@"x %@",info.txt];
            }
            btn.frame = CGRectMake(HROWSPACE +(HROWWIDTH+ HROWSPACE)* column,height +(HROWHEIHT+ HROWSPACE)*row, HROWWIDTH, HROWHEIHT);
            btn.tag = i;
            [btn setTitle:title forState:UIControlStateNormal];
            [self.mutB addObject:btn];
        }
    }
}

- (UIButton *)creatBtn:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [btn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [btn setLayerWithW:5 andColor:MAIN_COLOR andBackW:1];
    [btn addTarget:self action:action
                                forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

- (void)subCateBtn:(UIButton *)btn{
    ScreenDetailInfo *dInfo = self.mutA[btn.tag];
    dInfo.isSelect = NO;
    [btn removeFromSuperview];
    [self.mutB removeObject:btn];
    if (self.back) {
        self.back(_goods);
    }
}

- (void)subValueBtn:(UIButton *)btn{
    WeightInfo *dInfo = self.mutA[btn.tag];
    dInfo.txt = @"";
    dInfo.value = @"";
    [btn removeFromSuperview];
    [self.mutB removeObject:btn];
    if (self.back) {
        self.back(_goods);
    }
}

@end
