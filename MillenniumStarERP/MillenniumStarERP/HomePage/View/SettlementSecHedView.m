//
//  SettlementSecHedView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/6.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SettlementSecHedView.h"

@interface SettlementSecHedView()
@property (nonatomic,weak)UILabel *tLab;
@property (nonatomic,weak)UILabel *priceLab;
@end

@implementation SettlementSecHedView

+ (SettlementSecHedView *)creatView{
    SettlementSecHedView *headView = [[SettlementSecHedView alloc]init];
    return headView;
}

- (id)init{
    self = [super init];
    if (self) {
        [self creatHeadView];
    }
    return self;
}

- (void)creatHeadView{
    self.backgroundColor = [UIColor whiteColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
    lab.text = @"材料";
    lab.font = [UIFont systemFontOfSize:14];
    [self addSubview:lab];
    self.tLab = lab;
    
    UILabel *lab1 = [[UILabel alloc]init];
    NSString * headS = @"金额:￥28920.00";
    [self lab:lab1 withStr:headS];
    [self addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(@30);
    }];
    self.priceLab = lab1;
}

- (void)setSecInfo:(SettlementListInfo *)secInfo{
    if (secInfo) {
        _secInfo = secInfo;
        self.tLab.text = _secInfo.title;
        NSString *dePrice = [OrderNumTool strWithPrice:_secInfo.moneySum];
        NSString *str = [NSString stringWithFormat:@"金额:%@",dePrice];
        [self lab:self.priceLab withStr:str];
    }
}

- (void)lab:(UILabel *)lab withStr:(NSString *)str{
    NSInteger loc = str.length - 3;
    lab.font = [UIFont systemFontOfSize:14];
    NSMutableAttributedString *headMutS = [[NSMutableAttributedString alloc]initWithString:str];
    [headMutS addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, loc)];
    lab.attributedText = headMutS;
}

@end
