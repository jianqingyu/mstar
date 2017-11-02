//
//  EditUserInfoCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/6/28.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterCountInfo.h"
@interface EditUserInfoCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)MasterCountInfo *mInfo;
@property (weak, nonatomic) IBOutlet UITextField *shopFie;
@property (weak, nonatomic) IBOutlet UITextField *driFie;
@property (weak, nonatomic) IBOutlet UITextField *dri2Fie;
@property (weak, nonatomic) IBOutlet UITextField *dri3Fie;
@end
