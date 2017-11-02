//
//  BaseViewController.h
//  MillenniumStar08.07
//
//  Created by rogers on 15-8-13.
//  Copyright (c) 2015年 qxzx.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseViewController;
//1.定义协议 命名:类名+Delegate
@protocol BaseViewConDelegate <NSObject>
//方法的参数:第一参数是委托方自己,后面的参数可以为委托方发给代理方的辅助信息
@optional
- (void)netBack:(BaseViewController *)baseView andNet:(BOOL)isNet;
//- (void)netBigBack:(BaseViewController *)baseView andNet:(BOOL)isNet;
@end
@interface BaseViewController : UIViewController
@property(nonatomic,weak)id<BaseViewConDelegate> delegate;
- (void)creatNearNetView:(void (^)(BOOL isWifi))wifiBack;
@end
