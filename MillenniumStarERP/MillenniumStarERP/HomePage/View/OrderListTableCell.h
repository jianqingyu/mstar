//
//  OrderListTableCell.h
//  MillenniumStarERP
//
//  Created by yjq on 16/10/26.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListNewInfo.h"
@interface OrderListTableCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)OrderListNewInfo *listInfo;
@end
