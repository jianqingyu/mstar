//
//  CustomShowView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/8/11.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "CustomShowView.h"

@implementation CustomShowView

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CustomShowView" owner:nil options:nil][0];
    }
    return self;
}

@end
