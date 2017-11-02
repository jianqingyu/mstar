//
//  StausCount.h
//  MillenniumStarERP
//
//  Created by yjq on 16/12/16.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StausCount : NSObject
@property (nonatomic,assign)int waitForValidate;
@property (nonatomic,assign)int produceding;
@property (nonatomic,assign)int waitForSend;
@property (nonatomic,assign)int finished;
@end
