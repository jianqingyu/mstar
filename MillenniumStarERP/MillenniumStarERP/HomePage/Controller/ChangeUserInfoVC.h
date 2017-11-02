//
//  ChangeUserInfoVC.h
//  MillenniumStarERP
//
//  Created by yjq on 17/8/14.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^ChooseMessBack)(NSDictionary *dic);
@interface ChangeUserInfoVC : BaseViewController
@property (nonatomic,copy)ChooseMessBack back;
@end
