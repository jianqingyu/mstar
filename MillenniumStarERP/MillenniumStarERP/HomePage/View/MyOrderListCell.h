//
//  MyOrderListCell.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/5/10.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCustomerInfo.h"
@interface MyOrderListCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)UserCustomerInfo *info;
@end
