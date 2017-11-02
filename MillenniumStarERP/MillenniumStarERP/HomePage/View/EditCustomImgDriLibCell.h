//
//  EditCustomImgDriLibCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/7/26.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditCustomImgDriLibCell : UITableViewCell
@property (nonatomic,copy)NSArray *libArr;
@property (nonatomic,copy)NSString *titleStr;
+ (id)cellWithTableView:(UITableView *)tableView;
@end
