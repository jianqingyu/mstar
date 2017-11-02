//
//  CustomDriWordCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/8/8.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CusWordBack)(BOOL isSel,NSString *word);
@interface CustomDriWordCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,copy)NSString *word;
@property (nonatomic,copy)CusWordBack back;
@property (nonatomic,copy)NSString *cate;
@end
