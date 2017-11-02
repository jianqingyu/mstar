//
//  NakedDriSeaListInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 17/6/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NakedDriSeaListInfo : NSObject
@property (nonatomic,  copy)NSString *id;
@property (nonatomic,assign)BOOL isSel;
@property (nonatomic,  copy)NSString *CertAuth;
@property (nonatomic,  copy)NSString *CertCode;
@property (nonatomic,  copy)NSString *Weight;
@property (nonatomic,  copy)NSString *Price;
@property (nonatomic,  copy)NSString *percent;
@property (nonatomic,  copy)NSString *Shape;
@property (nonatomic,  copy)NSString *Color;
@property (nonatomic,  copy)NSString *Purity;
@property (nonatomic,  copy)NSString *Cut;
@property (nonatomic,  copy)NSString *Polishing;
@property (nonatomic,  copy)NSString *Symmetric;
@property (nonatomic,  copy)NSString *Fluorescence;
@property (nonatomic,strong)NSDictionary *modelWeightRange;

@end
