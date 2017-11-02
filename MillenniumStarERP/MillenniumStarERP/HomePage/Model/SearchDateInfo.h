//
//  SearchDateInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/24.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchDateInfo : NSObject
@property (nonatomic,  copy)NSString *key;
@property (nonatomic,  copy)NSString *title;
@property (nonatomic,  copy)NSString *sdate;
@property (nonatomic,  copy)NSString *edate;
@property (nonatomic,assign)BOOL isDefault;
@end
