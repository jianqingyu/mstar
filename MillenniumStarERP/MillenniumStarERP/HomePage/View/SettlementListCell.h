//
//  SettlementListCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/7.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelSListInfo.h"
@interface SettlementListCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,assign)BOOL isShow;
@property (nonatomic,strong)DelSListInfo *listInfo;
@end
