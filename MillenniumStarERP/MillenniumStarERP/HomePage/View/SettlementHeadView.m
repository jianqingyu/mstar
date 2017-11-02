//
//  SettlementHeadView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/3.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SettlementHeadView.h"
@interface SettlementHeadView()
@property (weak, nonatomic) IBOutlet UILabel *cusName;
@property (weak, nonatomic) IBOutlet UILabel *colorLab;
@property (weak, nonatomic) IBOutlet UILabel *comDate;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *dedate;
@property (weak, nonatomic) IBOutlet UILabel *orderDate;
@property (weak, nonatomic) IBOutlet UILabel *comNum;
@end
@implementation SettlementHeadView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"SettlementHeadView" owner:nil options:nil][0];
    }
    return self;
}

+ (id)createHeadView{
    return [[NSBundle mainBundle]loadNibNamed:@"SettlementHeadView" owner:nil options:nil][0];
}

- (void)setHeadInfo:(SettlementHeadInfo *)headInfo{
    if (headInfo) {
        _headInfo = headInfo;
        NSString *string = _headInfo.recDate;
        string = [string substringToIndex:10];//截取掉下标10之后的字符串
        NSString *string1 = _headInfo.orderDate;
        string1 = [string1 substringToIndex:10];//截取掉下标10之后的字符串
        self.cusName.text = _headInfo.customerName;
        self.colorLab.text = _headInfo.purityName;
        self.comDate.text = string;
        self.dedate.text = _headInfo.accountID;
        self.orderNum.text = _headInfo.orderNum;
        self.orderDate.text = string1;
        self.comNum.text = _headInfo.recNum;
    }
}

@end
