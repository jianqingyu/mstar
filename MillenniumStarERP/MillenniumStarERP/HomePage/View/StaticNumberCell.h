//
//  StaticNumberCell.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/11.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaticNumberCell : UITableViewCell
@property (nonatomic, copy)NSArray *infoArr;
+ (id)cellWithTableView:(UITableView *)tableView;
@end
