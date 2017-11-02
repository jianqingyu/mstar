//
//  CustomEditTableCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/7/17.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CustomEditBack)(id staue);
@interface CustomEditTableCell : UITableViewCell
@property (nonatomic,copy)CustomEditBack back;
+ (id)cellWithTableView:(UITableView *)tableView;
@end
