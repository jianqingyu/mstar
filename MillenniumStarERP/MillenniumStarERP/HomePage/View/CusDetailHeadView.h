//
//  CusDetailHeadView.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailHeadInfo.h"
@interface CusDetailHeadView : UIView
@property (nonatomic,strong)DetailHeadInfo *headInfo;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,copy) void (^ClickDrilBlock)(NSUInteger index);
+ (id)creatCustomDeHeadView;
@end
