//
//  SettlementHeadInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/3.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettlementHeadInfo : NSObject
@property (nonatomic,copy)NSString *recNum;
@property (nonatomic,copy)NSString *accountID;
@property (nonatomic,copy)NSString *orderNum;
@property (nonatomic,copy)NSString *customerName;
@property (nonatomic,copy)NSString *purityName;
@property (nonatomic,copy)NSString *recDate;
@property (nonatomic,copy)NSString *orderDate;
@property (nonatomic,copy)NSString *recOperator;
@property (nonatomic,assign)double totalPrice;
@property (nonatomic,copy)NSString *number;
@end
