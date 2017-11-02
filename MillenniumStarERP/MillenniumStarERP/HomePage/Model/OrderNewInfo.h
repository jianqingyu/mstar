//
//  OrderNewInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 16/11/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderNewInfo : NSObject
@property (nonatomic,assign)double goldPrice;
@property (nonatomic,copy)NSString *orderDate;
@property (nonatomic,copy)NSString *orderNum;
@property (nonatomic,copy)NSString *orderStatus;
@property (nonatomic,copy)NSString *customerName;
@property (nonatomic,copy)NSString *purityName;
@property (nonatomic,copy)NSString *qualityName;
@property (nonatomic,copy)NSString *word;
@property (nonatomic,copy)NSString *invoiceTitle;
@property (nonatomic,copy)NSString *orderNote;
@property (nonatomic,assign)NSString *invoiceType;
@end
