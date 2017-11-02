//
//  ProgressListCell.h
//  MillenniumStarERP
//
//  Created by yjq on 16/12/20.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressListInfo.h"
static CGFloat proHeight = 30;
static CGFloat proMar = 10;
@interface ProgressListCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)ProgressListInfo *proInfo;
@property (nonatomic,assign)float totalNum;

@end
