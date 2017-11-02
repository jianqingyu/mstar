//
//  CusHauteCoutureView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/8/8.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CusHauBack)(int staue,BOOL isYes);
@interface CusHauteCoutureView : UIView
@property (nonatomic,copy)CusHauBack driBack;
@end
