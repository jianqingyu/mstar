//
//  EditCustomDriTableCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/7/21.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTypeInfo.h"
typedef void (^editFieBack)(NSArray *infoArr);
@interface EditCustomDriTableCell : UITableViewCell
@property (nonatomic,  copy)NSString *number;
@property (nonatomic,  copy)NSString *weight;
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,  copy)editFieBack fieBack;
@end
