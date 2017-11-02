//
//  CustomPickView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQTextView.h"
typedef void (^CustomBtmPickBack)(int staue,id model);
@interface CustomPickView : UIView
@property (nonatomic,assign)int staue;
@property (nonatomic,assign)BOOL isCus;
@property (nonatomic,  copy)NSString *titleStr;
@property (nonatomic,  copy)NSString *selTitle;
@property (nonatomic,  copy)NSArray *typeList;
@property (nonatomic,strong)NSIndexPath *section;
@property (nonatomic,  copy)CustomBtmPickBack popBack;

@end
