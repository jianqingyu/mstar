//
//  ProduceHeadView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/11/21.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ProduceHeadView.h"
@interface ProduceHeadView()
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLab;
@property (weak, nonatomic) IBOutlet UILabel *conrimDateLab;
@property (weak, nonatomic) IBOutlet UILabel *otherInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *invoiceLab;
@property (weak, nonatomic) IBOutlet UILabel *noteLab;
@end
@implementation ProduceHeadView

+ (id)view{
    return [[NSBundle mainBundle]loadNibNamed:@"ProduceHeadView" owner:nil options:nil][0];
}

- (void)setOrderInfo:(ProduceOrderInfo *)orderInfo{
    if (orderInfo) {
        _orderInfo = orderInfo;
        self.orderNumLab.text = _orderInfo.orderNum;
        self.orderDateLab.text = _orderInfo.orderDate;
        self.conrimDateLab.text = _orderInfo.confirmDate;
        self.otherInfoLab.text = _orderInfo.otherInfo;
        self.noteLab.text = [NSString stringWithFormat:@"备注:%@",_orderInfo.orderNote];
        if (_orderInfo.invoiceTitle.length>0) {
            NSString * invoStr = [NSString stringWithFormat:@"类型:%@ 抬头:%@",_orderInfo.invoiceType,
                                  _orderInfo.invoiceTitle];
            self.invoiceLab.text = invoStr;
        }
        CGRect rect = CGRectMake(0, 0, SDevWidth-30, 999);
        rect = [self.otherInfoLab textRectForBounds:rect limitedToNumberOfLines:0];
        CGRect rect2 = CGRectMake(0, 0, SDevWidth-30, 999);
        rect2 = [self.noteLab textRectForBounds:rect2 limitedToNumberOfLines:0];
        self.high = 127+rect.size.height+rect2.size.height;
        self.clipsToBounds = YES;
    }
}

@end
