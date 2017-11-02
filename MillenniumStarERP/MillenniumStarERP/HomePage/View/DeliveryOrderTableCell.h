//
//  DeliveryOrderTableCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/3.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryListInfo.h"
@interface DeliveryOrderTableCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)DeliveryListInfo *deliveryInfo;
@end
