//
//  DeliveryOrderHeadView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/3.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "DeliveryOrderHeadView.h"
@interface DeliveryOrderHeadView()
@property (weak, nonatomic) IBOutlet UILabel *cusName;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *deliveryNum;
@property (weak, nonatomic) IBOutlet UILabel *colorLab;
@property (weak, nonatomic) IBOutlet UILabel *goldLab;
@property (weak, nonatomic) IBOutlet UILabel *totalNum;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@end

@implementation DeliveryOrderHeadView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"DeliveryOrderHeadView" owner:nil options:nil][0];
    }
    return self;
}

+ (id)createHeadView{
    return [[NSBundle mainBundle]loadNibNamed:@"DeliveryOrderHeadView" owner:nil options:nil][0];
}

- (void)setDelHInfo:(DeliveryHeadInfo *)delHInfo{
    if (delHInfo) {
        _delHInfo = delHInfo;
        self.cusName.text = _delHInfo.customerName;
        self.orderNum.text = _delHInfo.orderNum;
        self.deliveryNum.text = _delHInfo.moNum;
        self.colorLab.text = _delHInfo.purityName;
        self.goldLab.text = [NSString stringWithFormat:@"￥%0.1f",_delHInfo.goldPrice];
        self.totalNum.text = [NSString stringWithFormat:@"%@件",_delHInfo.number];
        self.priceLab.text = [OrderNumTool strWithPrice:_delHInfo.totalPrice];
    }
}

@end
