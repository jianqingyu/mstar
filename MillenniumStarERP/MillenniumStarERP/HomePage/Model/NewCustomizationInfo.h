//
//  NewCustomizationInfo.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2017/12/12.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewCustomizationInfo : NSObject
@property (nonatomic,  copy)NSString *pid;
@property (nonatomic,  copy)NSString *partSort;
@property (nonatomic,  copy)NSString *partCount;
@property (nonatomic,  copy)NSString *title;
@property (nonatomic,  copy)NSString *pics;
@property (nonatomic,  copy)NSString *picm;
@property (nonatomic,  copy)NSString *picb;
@property (nonatomic,  copy)NSArray *modelPartCount;
@property (nonatomic,  copy)NSDictionary *selectProItem;
@property (nonatomic,assign)float price;
@end
