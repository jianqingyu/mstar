//
//  NakedDriDetailHeadV.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriDetailHeadV.h"
@interface NakedDriDetailHeadV()
@property (weak, nonatomic) IBOutlet UILabel *staueLab;
@property (weak, nonatomic) IBOutlet UILabel *customLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *addNameLab;
@property (weak, nonatomic) IBOutlet UILabel *addPhoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *remakeLab;
@end

@implementation NakedDriDetailHeadV

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"NakedDriDetailHeadV" owner:nil options:nil][0];
    }
    return self;
}

+ (id)createHeadView{
    return [[NSBundle mainBundle]loadNibNamed:@"NakedDriDetailHeadV" owner:nil options:nil][0];
}

- (void)setHInfo:(NakedDriDetailHInfo *)hInfo{
    if (hInfo) {
        _hInfo = hInfo;
        self.staueLab.text = _hInfo.orderStatusTitle;
        self.customLab.text = [NSString stringWithFormat:@"客户 %@",_hInfo.customerName];
        self.orderNumLab.text = [NSString stringWithFormat:@"订单编号 %@",_hInfo.orderNum];
        self.addNameLab.text = _hInfo.postName;
        self.addPhoneLab.text = _hInfo.postTel;
        self.addressLab.text = _hInfo.postAddress;
        
        self.priceLab.text = [OrderNumTool strWithPrice:_hInfo.totelPrice];
        self.numLab.text = _hInfo.orderNumber;
        NSString *string = _hInfo.orderDate;
        string = [string substringToIndex:10];//截取掉下标10之后的字符串
        self.dateLab.text = string;
        self.remakeLab.text = _hInfo.remark;
    }
}

@end
