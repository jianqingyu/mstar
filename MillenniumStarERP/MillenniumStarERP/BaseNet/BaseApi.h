//
//  BaseApi.h
//  MillenniumStar08.07
//
//  Created by rogers on 15-8-13.
//  Copyright (c) 2015年 qxzx.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseResponse.h"

@interface BaseApi : NSObject

+ (void)getNoGeneralData:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL
                     params:(NSMutableDictionary*)params;
+ (void)getNewVerData:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL
               params:(NSMutableDictionary*)params;
/*通用接口
 */
+ (void)getGeneralData:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL params:(NSMutableDictionary*)params;
+ (void)postGeneralData:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL params:(NSMutableDictionary*)params;
/*
取消所有队列
 */
+(void)cancelAllOperation;
@end
