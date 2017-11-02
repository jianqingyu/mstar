//
//  ChooseInvoiceCell.h
//  MillenniumStarERP
//
//  Created by yjq on 16/12/15.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTypeInfo.h"
@interface ChooseInvoiceCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)DetailTypeInfo *deInfo;
@end
