//
//  ProgressHeadView.h
//  MillenniumStarERP
//
//  Created by yjq on 16/12/20.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProOrderInfo.h"
@interface ProgressHeadView : UIView
+ (id)createHeadView;
@property (nonatomic,strong)ProOrderInfo *orderInfo;
@end
