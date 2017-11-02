//
//  ScreeningTableCell.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/22.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreeningInfo.h"
#define COLUMN 3
#define ROWHEIHT 36
#define ROWSPACE 10
#define ROWWIDTH (SDevWidth*0.8 - 4*ROWSPACE)/3
typedef void (^ScreenClickBack)(id data);
@interface ScreeningTableCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)ScreeningInfo *info;
@property (nonatomic,copy)ScreenClickBack clickblock;
@property (nonatomic,weak)UITextField *minFie;
@property (nonatomic,weak)UITextField *maxFie;
@end
