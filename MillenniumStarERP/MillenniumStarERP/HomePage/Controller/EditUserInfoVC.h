//
//  EditUserInfoVC.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/7.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^EditUserBack)(id isSel);
@interface EditUserInfoVC : BaseViewController
@property (nonatomic,assign)BOOL *isTpye;
@property (nonatomic,copy)EditUserBack editBack;
@end
