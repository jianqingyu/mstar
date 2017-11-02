//
//  ScreeningHeadSView.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/22.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreeningHeadSView : UIView
- (id)initWithFrame:(CGRect)frame WithIdx:(NSInteger)section
           andTitle:(NSString *)title;
@property (nonatomic, copy) void (^didScreenWithIndex)(NSInteger index);
@end
