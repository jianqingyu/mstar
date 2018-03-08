//
//  StorageDataTool.h
//  MillenniumStarERP
//
//  Created by yjq on 17/8/14.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductInfo.h"
#import "CustomerInfo.h"
#import "AddressInfo.h"
#import "DetailTypeInfo.h"
#import "NakedDriSeaListInfo.h"
@interface StorageDataTool : NSObject
+ (instancetype)shared;
@property (nonatomic,assign)BOOL isMain;
@property (nonatomic,  copy)NSString *word;
@property (nonatomic,  copy)NSString *note;
@property (nonatomic,  copy)NSString *handSize;
@property (nonatomic,strong)AddressInfo *addInfo;
@property (nonatomic,strong)CustomerInfo *cusInfo;
@property (nonatomic,strong)ProductInfo *BaseInfo;
@property (nonatomic,strong)DetailTypeInfo *colorInfo;
@property (nonatomic,strong)NakedDriSeaListInfo *BaseSeaInfo;
@end
