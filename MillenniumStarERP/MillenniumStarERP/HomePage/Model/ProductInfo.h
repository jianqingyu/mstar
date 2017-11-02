//
//  ProductInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/29.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductInfo : NSObject
@property (nonatomic,assign)int id;
@property (nonatomic,assign)float price;
@property (nonatomic,copy)NSString *pic;
@property (nonatomic,copy)NSString *picb;
@property (nonatomic,copy)NSString *picm;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *weight;
@property (nonatomic,strong)NSDictionary *stoneWeightRange;

@end
