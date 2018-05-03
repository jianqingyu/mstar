//
//  BulkOrderInfo.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/3/28.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BulkOrderInfo : NSObject
@property (nonatomic,  copy)NSString *id;
@property (nonatomic,  copy)NSString *modelNum;
@property (nonatomic,  copy)NSString *number;
@property (nonatomic,  copy)NSString *purity;
@property (nonatomic,  copy)NSString *handSize;
@property (nonatomic,  copy)NSString *message;
@property (nonatomic,assign)BOOL isErr;
@end
