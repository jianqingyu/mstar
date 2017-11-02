//
//  NearbyNetworkView.h
//  MillenniumStar
//
//  Created by yjq on 15/8/5.
//  Copyright (c) 2015年 Millennium Star. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^nearworkBack)(BOOL isSel);
@interface NearbyNetworkView : UIView
+ (NearbyNetworkView *)creatBigNetView;
@property (nonatomic,copy)nearworkBack loadBack;
@end
