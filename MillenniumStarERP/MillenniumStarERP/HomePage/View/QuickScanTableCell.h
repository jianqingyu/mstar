//
//  QuickScanTableCell.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/1/31.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
typedef void (^QuickCellBack)(BOOL isSel,NSString*messArr);
@interface QuickScanTableCell : UITableViewCell
@property (nonatomic, copy) NSString *colur;
@property (nonatomic, copy) NSString *messArr;
@property (nonatomic, copy) NSString *handSize;
@property (nonatomic, copy) QuickCellBack MessBack;
@property (nonatomic,strong)DetailModel *modelInfo;
+ (id)cellWithTableView:(UITableView *)tableView;
@end
