//
//  SettlementListHeadView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/7.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SettlementListHeadView.h"
@interface SettlementListHeadView()
@property (weak, nonatomic) IBOutlet UILabel *recNumLab;
@property (weak, nonatomic) IBOutlet UILabel *customerLab;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLab;
@property (weak, nonatomic) IBOutlet UILabel *recDateLab;
@property (weak, nonatomic) IBOutlet UILabel *purLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *toLab;
@end
@implementation SettlementListHeadView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"SettlementListHeadView" owner:nil options:nil][0];
    }
    return self;
}

+ (id)createHeadView{
    return [[NSBundle mainBundle]loadNibNamed:@"SettlementListHeadView" owner:nil options:nil][0];
}

- (void)setHeadInfo:(OrderSetmentInfo *)headInfo{
    if (headInfo) {
        _headInfo = headInfo;
        [self.toLab setAdjustsFontSizeToFitWidth:YES];
        NSString *string = _headInfo.recDate;
        string = [string substringToIndex:10];//截取掉下标10之后的字符串
        NSString *string1 = _headInfo.orderDate;
        string1 = [string1 substringToIndex:10];//截取掉下标10之后的字符串
        self.recNumLab.text = [NSString stringWithFormat:@"结算单号 %@",_headInfo.recNum];
        self.customerLab.text = [NSString stringWithFormat:@"客户名称 : %@",_headInfo.customerName];
        self.recDateLab.text = [NSString stringWithFormat:@"结算日期 : %@",string];
        self.orderDateLab.text = [NSString stringWithFormat:@"下单日期 : %@",string1];
        self.purLab.text = [NSString stringWithFormat:@"成色 : %@",_headInfo.purityName];
        self.numLab.text = [NSString stringWithFormat:@"数量 : %@件",_headInfo.number];
        self.priceLab.text = [OrderNumTool strWithPrice:_headInfo.totalPrice];
        self.priceLab.hidden = !self.isShow;
    }
}

- (IBAction)clickBtn:(id)sender {
    if (self.clickBack) {
        self.clickBack(YES);
    }
}

@end
