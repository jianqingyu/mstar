//
//  RequestClient.h
//  MillenniumStar08.07
//
//  Created by rogers on 15-8-13.
//  Copyright (c) 2015年 qxzx.com. All rights reserved.
//

#import "AFHTTPSessionManager.h"
static NSString * const ROOT_URL = @"http://www.citypasswifi.com/api/";
@interface RequestClient : AFHTTPSessionManager
+ (instancetype)sharedClient;
+ (instancetype)sharedPostClient;
- (BOOL)checkNetwork:(AFHTTPSessionManager*)manager;
@end
