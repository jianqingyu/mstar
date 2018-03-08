//
//  SaveColorData.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/3/5.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailTypeInfo.h"
@interface SaveColorData : NSObject
+ (instancetype)shared;
@property (nonatomic,strong)DetailTypeInfo *colorInfo;
@end
