//
//  OrderListNewInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 16/11/11.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListNewInfo : NSObject
@property (nonatomic,assign)int id;
@property (nonatomic,copy)NSString *orderNum;
@property (nonatomic,copy)NSString *customerName;
@property (nonatomic,copy)NSString *orderDate;
@property (nonatomic,copy)NSString *modifyDate;
@property (nonatomic,copy)NSString *confirmDate;
@property (nonatomic,assign)float totalPrice;
@property (nonatomic,assign)float needPayPrice;
@property (nonatomic,copy)NSString *otherInfo;
@property (nonatomic,copy)NSString *orderStatusTitle;
@property (nonatomic,copy)NSArray *pics;
@property (nonatomic,copy)NSString *purityName;
@property (nonatomic,copy)NSString *number;
@property (nonatomic,copy)NSString *moNum;
@property (nonatomic,copy)NSString *recNum;
@property (nonatomic,copy)NSString *recBillNum;
@end
