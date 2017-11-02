//
//  DeliveryOrderHeadView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/3.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryHeadInfo.h"
@interface DeliveryOrderHeadView : UIView
+ (id)createHeadView;
@property (nonatomic,strong)DeliveryHeadInfo *delHInfo;
@end
