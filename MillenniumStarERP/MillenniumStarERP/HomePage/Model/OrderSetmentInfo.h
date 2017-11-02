//
//  OrderSetmentInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/9.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderSetmentInfo : NSObject
@property (nonatomic,copy)NSString *recNum;
@property (nonatomic,copy)NSString *customerName;
@property (nonatomic,copy)NSString *orderDate;
@property (nonatomic,copy)NSString *recDate;
@property (nonatomic,copy)NSString *purityName;
@property (nonatomic,copy)NSString *number;
@property (nonatomic,assign)double totalPrice;
@property (nonatomic,copy)NSArray *moList;
@end
