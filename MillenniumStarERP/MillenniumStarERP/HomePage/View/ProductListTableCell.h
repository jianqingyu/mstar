//
//  ProductListTableCell.h
//  MillenniumStar
//
//  Created by ❥°澜枫_ on 15/5/19.
//  Copyright (c) 2015年 Millennium Star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListTableCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *devItemArray;
//初始化
+ (id)cellWithTableView:(UITableView *)tableView andDelegate:(id)delegate with:(BOOL)isShow;
//数据更新
- (void)updateDevInfoWith:(NSMutableArray*)devInfoArray index:(int)index;
//- (void)updateNakedWith:(NSMutableArray*)devInfoArray index:(int)index;
@end
