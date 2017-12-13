//
//  NewCusBottomView.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2017/12/11.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NewCusBottomView.h"

@implementation NewCusBottomView

+ (id)creatBottomView{
    return [[NSBundle mainBundle]loadNibNamed:@"NewCusBottomView" owner:nil options:nil][0];
}

- (IBAction)close:(id)sender {
    if (self.back) {
        self.back(0);
    }
}

- (IBAction)sureClick:(id)sender {
    if (self.back) {
        self.back(1);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
