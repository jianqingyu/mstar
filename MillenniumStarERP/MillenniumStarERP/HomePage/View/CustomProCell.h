//
//  CustomProCell.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/13.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CustomProBack)(id index);
@interface CustomProCell : UITableViewCell
@property (nonatomic,  copy)CustomProBack tableBack;
@property (nonatomic,  copy)NSString *titleStr;
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,strong)NSArray *list;
@property (nonatomic,assign)NSInteger seIndex;
@property (nonatomic,assign)NSString *number;
@property (nonatomic,assign)BOOL isSel;
+ (id)cellWithTableView:(UITableView *)tableView;
@end
