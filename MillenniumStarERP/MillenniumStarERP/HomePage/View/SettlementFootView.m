//
//  SettlementFootView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/6.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SettlementFootView.h"
@interface SettlementFootView()
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *orderName;
@end
@implementation SettlementFootView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"SettlementFootView" owner:nil options:nil][0];
    }
    return self;
}

+ (id)createHeadView{
    return [[NSBundle mainBundle]loadNibNamed:@"SettlementFootView" owner:nil options:nil][0];
}

- (void)setFootInfo:(SettlementHeadInfo *)footInfo{
    if (footInfo) {
        _footInfo = footInfo;
        self.numLab.text = [NSString stringWithFormat:@"%@件",_footInfo.number];
        self.orderName.text = _footInfo.recOperator;
        
        self.priceLab.text = [OrderNumTool strWithPrice:_footInfo.totalPrice];
    }
}

@end
