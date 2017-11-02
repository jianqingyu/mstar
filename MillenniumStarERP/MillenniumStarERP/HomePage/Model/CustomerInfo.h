//
//  CustomerInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 16/10/25.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerInfo : NSObject
@property (nonatomic,assign)int customerID;
@property (nonatomic,copy)NSString *keycode;
@property (nonatomic,copy)NSString *customerName;
@property (nonatomic,copy)NSString *customerFullName;
@end
