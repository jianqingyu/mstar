//
//  Account.h
//  MillenniumStar08.07
//
//  Created by yjq on 15/10/10.
//  Copyright © 2015年 qxzx.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject<NSCoding>
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,copy)NSString *password;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *tokenKey;
@property (nonatomic,copy)NSNumber *isNoShow;
@property (nonatomic,copy)NSNumber *isNoDriShow;
@property (nonatomic,copy)NSNumber *isNorm;
+ (instancetype)accountWithDict:(NSDictionary *)dict;
@end
