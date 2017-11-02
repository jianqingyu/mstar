//
//  SettlementFootView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/6.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettlementHeadInfo.h"
@interface SettlementFootView : UIView
+ (id)createHeadView;
@property (nonatomic,strong)SettlementHeadInfo *footInfo;
@end
