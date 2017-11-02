//
//  NakedDriConfirmCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/6/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedDriConfirmInfo.h"
typedef void (^NakedDriConBack)(BOOL isDel);
@interface NakedDriConfirmCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,copy)NakedDriConBack back;
@property (nonatomic,strong)NakedDriConfirmInfo *conInfo;
@end
