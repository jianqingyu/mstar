//
//  NakedDriAllListCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/6/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedDriOListInfo.h"
typedef void (^NakedPayBack)(BOOL isSel);
@interface NakedDriAllListCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)NakedDriOListInfo *info;
@property (nonatomic,  copy)NSString *staue;
@property (nonatomic,copy)NakedPayBack back;
@end
