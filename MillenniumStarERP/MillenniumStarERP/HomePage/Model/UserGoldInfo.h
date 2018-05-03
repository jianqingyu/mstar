//
//  UserGoldInfo.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/24.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserGoldInfo : NSObject
@property (nonatomic,  copy)NSString *PurityID;
@property (nonatomic,  copy)NSString *PurityName;
@property (nonatomic,  copy)NSString *GoldDate;
@property (nonatomic,assign)float UnitPrice;
@end
