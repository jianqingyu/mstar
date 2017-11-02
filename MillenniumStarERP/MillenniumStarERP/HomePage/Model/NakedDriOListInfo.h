//
//  NakedDriOListInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 17/6/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NakedDriOListInfo : NSObject
@property (nonatomic,  copy)NSString *id;
@property (nonatomic,  copy)NSString *orderNum;
@property (nonatomic,  copy)NSString *orderDate;
@property (nonatomic,  copy)NSString *customerName;
@property (nonatomic,  copy)NSString *remark;
@property (nonatomic,assign)float totalPrice;
@property (nonatomic,  copy)NSString *number;

@end
