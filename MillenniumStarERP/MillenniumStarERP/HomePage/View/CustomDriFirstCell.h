//
//  CustomDriFirstCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/8/8.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
typedef void (^CusDriFirBack)(BOOL isSel,NSString*messArr);
@interface CustomDriFirstCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *colourLab;
@property (weak, nonatomic) IBOutlet UITextField *fie1;
@property (weak, nonatomic) IBOutlet UIButton *handbtn;
@property (nonatomic, copy) NSString *colur;
@property (nonatomic, copy) NSString *messArr;
@property (nonatomic, copy) NSString *handSize;
@property (nonatomic, copy) NSString *certCode;
@property (nonatomic, copy) CusDriFirBack MessBack;
@property (nonatomic,strong)DetailModel *modelInfo;
+ (id)cellWithTableView:(UITableView *)tableView;
@end
