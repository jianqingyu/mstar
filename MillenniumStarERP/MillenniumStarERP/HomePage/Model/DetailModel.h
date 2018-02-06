//
//  DetailModel.h
//  MillenniumStarERP
//
//  Created by yjq on 16/10/18.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject
@property (nonatomic,  copy)NSString *id;
@property (nonatomic,  copy)NSString *title;
@property (nonatomic,  copy)NSString *weight;
@property (nonatomic,  copy)NSString *categoryTitle;
@property (nonatomic,  copy)NSString *remark;
@property (nonatomic,  copy)NSArray *pics;
@property (nonatomic,  copy)NSString *handSize;
@property (nonatomic,  copy)NSString *number;
@property (nonatomic,assign)float price;
@property (nonatomic,assign)int categoryId;
@property (nonatomic,assign)BOOL isSelfStone;
@property (nonatomic,strong)NSDictionary *stone;
@property (nonatomic,strong)NSDictionary *stoneA;
@property (nonatomic,strong)NSDictionary *stoneB;
@property (nonatomic,strong)NSDictionary *stoneC;
@end
