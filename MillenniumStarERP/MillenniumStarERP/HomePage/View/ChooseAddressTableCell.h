//
//  ChooseAddressTableCell.h
//  MillenniumStarERP
//
//  Created by yjq on 16/10/24.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressInfo.h"
typedef void (^ChooseAddBack)(int index);
@interface ChooseAddressTableCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,retain)AddressInfo *userAddInfo;
@property (nonatomic,copy) ChooseAddBack addBack;
@end
