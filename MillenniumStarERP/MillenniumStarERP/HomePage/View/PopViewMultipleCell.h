//
//  PopViewMultipleCell.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/12.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQTagView.h"
@interface PopViewMultipleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet YQTagView *tagView;
+ (id)cellWithTableView:(UITableView *)tableView;
- (void)setCellWithInfo:(NSArray *)list
              forInPath:(NSIndexPath *)indexPath;
@end
