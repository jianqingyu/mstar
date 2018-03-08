//
//  CustomFirstCell.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
typedef void (^DisBack)(BOOL isSel);
typedef void (^CustomFirBack)(BOOL isSel,NSString*messArr);
@interface CustomFirstCell : UITableViewCell
@property (weak,  nonatomic) IBOutlet UITextField *fie1;
@property (weak,  nonatomic) IBOutlet UITextField *handFie;
@property (nonatomic,  copy) NSString *messArr;
@property (nonatomic,  copy) NSString *handSize;
@property (nonatomic,  copy) NSString *certCode;
@property (nonatomic,assign) BOOL isNew;
@property (nonatomic,assign) int refresh;
@property (nonatomic,  copy) CustomFirBack MessBack;
@property (nonatomic,  copy) DisBack dBack;
@property (nonatomic,strong) DetailModel *modelInfo;
@property (assign,nonatomic) int editId;
@property (nonatomic,  copy) NSString *colur;
@property (nonatomic,strong) NSDictionary *dic;
+ (id)cellWithTableView:(UITableView *)tableView;
@end
