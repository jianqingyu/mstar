//
//  NewBaseApi.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/3/15.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseResponse.h"

@class NewBaseApi;
@protocol NewBaseApiDelegate <NSObject>
- (void)getGen:(NewBaseApi *)netApi resData:(BaseResponse *)response andErr:(NSError *)error;
@end

@interface NewBaseApi : NSObject
@property (nonatomic,  weak)id<NewBaseApiDelegate> delegate;
+ (instancetype)sharedBaseAPi;
- (void)getGeneralRequestURL:(NSString*)requestURL
                      params:(NSMutableDictionary*)params;
@end
