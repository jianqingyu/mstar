//
//  InformationCell.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/7.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInfo.h"
@interface InformationCell : UITableViewCell
+ (InformationCell *)cellWithTableView:(UITableView*)tableView;
@property (nonatomic,strong)MessageInfo*messInfo;
@end
