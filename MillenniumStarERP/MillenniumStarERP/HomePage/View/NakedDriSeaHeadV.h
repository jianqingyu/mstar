//
//  NakedDriSeaHeadV.h
//  MillenniumStarERP
//
//  Created by yjq on 17/6/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^NakedDriSeaHBack)(NSString *mess);
@interface NakedDriSeaHeadV : UIView
@property (nonatomic,strong)NSArray *topArr;
@property (nonatomic,  copy)NakedDriSeaHBack back;
@property (nonatomic,  copy)NSString *string;
@end
