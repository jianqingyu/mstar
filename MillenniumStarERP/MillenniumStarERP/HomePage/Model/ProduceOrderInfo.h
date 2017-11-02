//
//  ProduceOrderInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 16/12/5.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProduceOrderInfo : NSObject
@property (nonatomic,copy)NSString *orderNum;
@property (nonatomic,copy)NSString *customerName;
@property (nonatomic,copy)NSString *orderDate;
@property (nonatomic,copy)NSString *confirmDate;
@property (nonatomic,copy)NSString *otherInfo;
@property (nonatomic,assign)double totalPrice;
@property (nonatomic,assign)double needPayPrice;
@property (nonatomic,copy)NSString *orderStatusTitle;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *invoiceTitle;
@property (nonatomic,copy)NSString *orderNote;
@property (nonatomic,assign)NSString *invoiceType;
@end
