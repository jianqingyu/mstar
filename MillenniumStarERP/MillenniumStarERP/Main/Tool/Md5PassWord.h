//
//  Md5PassWord.h
//  CityHousekeeper
//
//  Created by yjq on 15/12/2.
//  Copyright © 2015年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Md5PassWord : NSObject
/* md5加密**/
+ (NSString *)md5:(NSString *)input;
+ (NSString *)md5Pass:(NSString *)key;
@end
