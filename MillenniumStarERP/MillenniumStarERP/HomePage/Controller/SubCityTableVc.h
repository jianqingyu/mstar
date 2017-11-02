//
//  SubCityTableVc.h
//  MillenniumStar
//
//  Created by yjq on 15/7/27.
//  Copyright (c) 2015年 Millennium Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Citys.h"
@interface SubCityTableVc : UITableViewController
@property (nonatomic,strong)Citys *city;
@property (nonatomic,assign)int provinceID;
@end
