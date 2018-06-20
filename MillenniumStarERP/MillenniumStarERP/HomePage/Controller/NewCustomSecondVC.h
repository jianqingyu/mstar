//
//  NewCustomSecondVC.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/5/16.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^NewCusSecondBack)(id model);
@interface NewCustomSecondVC : BaseViewController
@property (nonatomic,assign)int isEd;
@property (nonatomic,assign)int proId;
@property (nonatomic,  copy)NewCusSecondBack back;
@end
