//
//  StaticImgCell.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/11.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticNumInfo.h"
@interface StaticImgCell : UITableViewCell
@property (nonatomic,strong)StaticNumInfo *numInfo;
+ (id)cellWithTableView:(UITableView *)tableView;
@end
