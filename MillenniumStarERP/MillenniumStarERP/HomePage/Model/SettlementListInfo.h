//
//  SettlementListInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/3.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettlementListInfo : NSObject
@property (nonatomic,  copy)NSString *title;
@property (nonatomic,  copy)NSArray *list;
@property (nonatomic,assign)double moneySum;
@end
