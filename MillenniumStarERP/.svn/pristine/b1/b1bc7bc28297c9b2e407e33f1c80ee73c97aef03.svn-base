//
//  ShowLoginViewTool.h
//  MillenniumStarERP
//
//  Created by yjq on 16/11/3.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^toolBack)(id result);
@interface ShowLoginViewTool : NSObject
@property (nonatomic,strong)NSMutableDictionary *dict;
@property (nonatomic,copy)NSString *url;
@property (nonatomic,copy)toolBack toBack;
+ (ShowLoginViewTool *)creatTool;
- (void)showLoginView:(BOOL)isBack;
@end
