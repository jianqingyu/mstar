//
//  ScreeningTopView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/6/16.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HCOLUMN (IsPhone?3:5)
#define HROWHEIHT 26
#define HROWSPACE 5
#define HROWWIDTH (MIN(SDevHeight, SDevWidth)*0.8 - (HCOLUMN+1)*HROWSPACE)/HCOLUMN
typedef void (^ScreenTBack)(NSArray *goods);
@interface ScreeningTopView : UIView
@property (nonatomic,  copy) NSArray *values;
@property (nonatomic,  copy) NSArray*goods;
@property (nonatomic,  copy) ScreenTBack back;
@end
