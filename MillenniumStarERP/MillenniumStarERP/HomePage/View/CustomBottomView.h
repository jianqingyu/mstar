//
//  CustomBottomView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/4/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CustomBtmPopBack)(id model);
@interface CustomBottomView : UIView
@property (nonatomic,copy)NSArray *typeList;
@property (nonatomic,strong)NSIndexPath *section;
@property (nonatomic,copy)CustomBtmPopBack popBack;
@end

