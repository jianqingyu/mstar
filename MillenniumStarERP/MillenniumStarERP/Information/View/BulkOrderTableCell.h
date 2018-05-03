//
//  BulkOrderTableCell.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/3/27.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BulkOrderInfo.h"
@interface BulkOrderTableCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)BulkOrderInfo *info;
@end
