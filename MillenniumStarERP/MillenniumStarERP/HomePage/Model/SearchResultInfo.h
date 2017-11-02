//
//  SearchResultInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/20.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultInfo : NSObject
@property (nonatomic,  copy)NSString *orderNum;
@property (nonatomic,  copy)NSString *customerName;
@property (nonatomic,  copy)NSString *orderDate;
@property (nonatomic,  copy)NSString *purityName;
@property (nonatomic,  copy)NSString *number;
@property (nonatomic,assign)double goldPrice;

@end
