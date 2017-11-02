//
//  FinishedProFCell.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/26.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinishedProFCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *mPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *listLab;
@property (weak, nonatomic) IBOutlet UIButton *minBtn;
@property (weak, nonatomic) IBOutlet UIButton *numBtn;
@property (weak, nonatomic) IBOutlet UIButton *maxBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIButton *addShopBtn;
@end
