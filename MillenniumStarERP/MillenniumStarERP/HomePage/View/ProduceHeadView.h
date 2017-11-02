//
//  ProduceHeadView.h
//  MillenniumStarERP
//
//  Created by yjq on 16/11/21.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProduceOrderInfo.h"
@interface ProduceHeadView : UIView
+ (id)view;
@property (nonatomic,strong)ProduceOrderInfo *orderInfo;
@property (nonatomic,assign)CGFloat high;
@end
