//
//  ConfirmCollHeadView.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/18.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "ConfirmCollHeadView.h"
@interface ConfirmCollHeadView()
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *staueLab;
@end
@implementation ConfirmCollHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setStaueInfo:(OrderNewInfo *)staueInfo{
    if (staueInfo) {
        _staueInfo = staueInfo;
        self.orderNumLab.text = _staueInfo.orderNum;
        self.dateLab.text = _staueInfo.orderDate;
        self.staueLab.text = _staueInfo.orderStatus;
    }
}

@end
