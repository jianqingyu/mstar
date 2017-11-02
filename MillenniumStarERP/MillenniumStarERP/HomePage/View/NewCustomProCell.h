//
//  NewCustomProCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/7/17.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^newDriEditBack)(BOOL isSel);
@interface NewCustomProCell : UITableViewCell
@property (nonatomic,assign)BOOL isSel;
@property (nonatomic,assign)BOOL isCus;
@property (nonatomic,strong)NSArray *list;
@property (nonatomic,  copy)NSString *num;
@property (nonatomic,  copy)NSString *titleStr;
@property (nonatomic,  copy)NSString *certCode;
@property (nonatomic,  copy)newDriEditBack back;
+ (id)cellWithTableView:(UITableView *)tableView;
@end
