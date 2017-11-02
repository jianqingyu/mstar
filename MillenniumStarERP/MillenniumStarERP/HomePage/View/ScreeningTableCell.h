//
//  ScreeningTableCell.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/22.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreeningInfo.h"
#import "WeightInfo.h"
#define COLUMN (IsPhone?3:5)
#define ROWHEIHT 30
#define ROWSPACE 10
#define ROWWIDTH (MIN(SDevHeight, SDevWidth)*0.8 - (COLUMN+1)*ROWSPACE)/COLUMN
@interface ScreeningTableCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)ScreeningInfo *info;
@property (nonatomic,strong)WeightInfo *wInfo;
@property (nonatomic,  weak)UITextField *minFie;
@property (nonatomic,  weak)UITextField *maxFie;
@end
