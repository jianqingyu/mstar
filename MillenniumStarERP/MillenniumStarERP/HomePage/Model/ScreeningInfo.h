//
//  ScreeningInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/22.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScreeningInfo : NSObject
@property (nonatomic,assign)BOOL isOpen;
@property (nonatomic,assign)int id;
@property (nonatomic,assign)int sort;
@property (nonatomic,assign)BOOL mulSelect;
@property (nonatomic,  copy) NSString *title;
@property (nonatomic,  copy) NSString *groupKey;
@property (nonatomic,  copy) NSArray *attributeList;
@end
