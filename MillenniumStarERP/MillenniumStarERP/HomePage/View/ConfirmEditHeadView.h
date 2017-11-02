//
//  ConfirmEditHeadView.h
//  MillenniumStarERP
//
//  Created by yjq on 16/11/18.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderNewInfo.h"
@interface ConfirmEditHeadView : UIView
+ (id)createHeadView;
@property (nonatomic,strong)OrderNewInfo *staueInfo;
@end
