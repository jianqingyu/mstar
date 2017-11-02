//
//  NakedDriOrderDetailCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/6/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedDriDetailLInfo.h"
@interface NakedDriOrderDetailCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)NakedDriDetailLInfo *lInfo;
@end
