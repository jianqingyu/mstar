//
//  DeliveryListInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/3.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryListInfo : NSObject
@property (nonatomic,copy)NSString *modelNum;
@property (nonatomic,copy)NSString *typeName;
@property (nonatomic,copy)NSString *sInfo;
@property (nonatomic,copy)NSString *dInfo;
@property (nonatomic,copy)NSArray *stInfo;
@property (nonatomic,copy)NSString *remark;
@property (nonatomic,copy)NSString *pic;
@property (nonatomic,copy)NSString *modNum;
@property (nonatomic,assign)double unitPrice;
@property (nonatomic,assign)BOOL isOpen;

@end
