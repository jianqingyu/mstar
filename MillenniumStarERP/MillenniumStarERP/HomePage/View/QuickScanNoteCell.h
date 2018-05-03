//
//  QuickScanNoteCell.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/18.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickScanNoteCell : UITableViewCell
@property (nonatomic,copy)NSString *note;
+ (id)cellWithTableView:(UITableView *)tableView;
@end
