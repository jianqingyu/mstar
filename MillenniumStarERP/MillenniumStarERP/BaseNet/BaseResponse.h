//
//  BaseResponse.h
//  MillenniumStar08.07
//
//  Created by rogers on 15-8-13.
//  Copyright (c) 2015年 qxzx.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseResponse : NSObject
@property(copy,   nonatomic) NSString *message;
@property(strong, nonatomic) id data;
@property(assign, nonatomic) id error;
@property(assign, nonatomic) id response;
@end
