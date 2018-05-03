//
//  QuickScanListCell.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/9.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickScanListCell : UITableViewCell
typedef void (^QuickListBack)(id model);
@property (nonatomic,strong)NSArray *listArr;
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, copy)QuickListBack back;
@end
