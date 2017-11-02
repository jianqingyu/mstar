//
//  NakedDriLibSLabCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedDriLiblistInfo.h"
@interface NakedDriLibSLabCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)NakedDriLiblistInfo*textSInfo;
@end
