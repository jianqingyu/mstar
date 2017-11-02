//
//  CommonUsedTool.h
//  MillenniumStarERP
//
//  Created by yjq on 17/2/21.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUsedTool : NSObject
+ (void)loadUpDate:(void (^)(NSDictionary *response, NSError *error))callback
             image:(UIImage *)image Dic:(NSMutableDictionary *)params
               Url:(NSString *)url;
@end
