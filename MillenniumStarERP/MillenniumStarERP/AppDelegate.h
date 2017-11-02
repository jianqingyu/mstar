//
//  AppDelegate.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/5.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DelegateNetBack)(BOOL isSel);
typedef void (^AliPayCallBack)(BOOL isSuccess);
typedef void (^WeChatPayCallBack)(BOOL isSuccess);
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong,nonatomic) UIWindow *window;
@property (nonatomic,  copy)DelegateNetBack loadBack;
@property (nonatomic,  copy)AliPayCallBack aliPayCallBack;
@property (nonatomic,  copy)WeChatPayCallBack weChatPayBlock;
@property (nonatomic,assign)int shopNum;
@end

