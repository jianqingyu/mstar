//
//  ProgressHeadView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/12/20.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ProgressHeadView.h"
@interface ProgressHeadView()
@property (weak, nonatomic) IBOutlet UILabel *orderLab;
@property (weak, nonatomic) IBOutlet UILabel *conDataLab;
@property (weak, nonatomic) IBOutlet UILabel *otherLab;
@end

@implementation ProgressHeadView

+ (id)createHeadView{
    return [[NSBundle mainBundle]loadNibNamed:@"ProgressHeadView" owner:nil options:nil][0];
}

- (void)setOrderInfo:(ProOrderInfo *)orderInfo{
    if (orderInfo) {
        _orderInfo = orderInfo;
        self.orderLab.text = _orderInfo.orderNum;
        self.conDataLab.text = _orderInfo.ConfirmDate;
        self.otherLab.text = _orderInfo.otherInfo;
    }
}

@end
