//
//  YQDropdownMenu.h
//  YQ微博
//
//  Created by tarena425 on 15/7/1.
//  Copyright (c) 2015年 ccyuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YQDropdownMenu;

@protocol YQDropdownMenuDelagate <NSObject>
@optional
- (void)dropdownMenuDidDismiss:(YQDropdownMenu *)menu;
- (void)dropdownMenuDidShow:(YQDropdownMenu *)menu;
@end

@interface YQDropdownMenu : UIView
@property (nonatomic,weak)id <YQDropdownMenuDelagate>delegate;
+ (instancetype)menu;
/**
 * 显示
 */
- (void)showFrom:(UIView *)from;
/**
 * 销毁
 */
- (void)dismiss;
/**
 * 内容
 */
@property (nonatomic,strong)UIView *content;
/**
 * 内容控制器
 */
@property (nonatomic,strong)UIViewController *controller;
@end
