//
//  CustomTextField.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/14.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholder = @"输入搜索";
        self.font = [UIFont systemFontOfSize:14];
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.returnKeyType = UIReturnKeySearch;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return self;
}

@end
