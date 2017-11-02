//
//  CustomInputPassView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/8/4.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CPutcallBack)(BOOL isYes);
@interface CustomInputPassView : UIView
@property (nonatomic, copy)CPutcallBack clickBlock;
@end
