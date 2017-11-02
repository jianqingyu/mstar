//
//  OrderListInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 16/10/25.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListInfo : NSObject
@property (nonatomic,assign)BOOL isSel;
@property (nonatomic,assign)int id;
@property (nonatomic,assign)int modelId;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *pic;
@property (nonatomic,copy)NSString *baseInfo;
@property (nonatomic,assign)float price;
@property (nonatomic,assign)float needPayPrice;
@property (nonatomic,copy)NSString *number;
@property (nonatomic,copy)NSString *info;

@end
