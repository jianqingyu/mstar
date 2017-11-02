//
//  DeliveryHeadInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/3.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryHeadInfo : NSObject
@property (nonatomic,copy)NSString *moNum;
@property (nonatomic,copy)NSString *orderNum;
@property (nonatomic,copy)NSString *moDate;
@property (nonatomic,copy)NSString *customerName;
@property (nonatomic,copy)NSString *purityName;
@property (nonatomic,assign)double goldPrice;
@property (nonatomic,assign)double totalPrice;
@property (nonatomic,copy)NSString *number;
@end
