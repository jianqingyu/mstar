//
//  NewCustomizationVC.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2017/12/7.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^NewCusEdDateBack)(id model);
@interface NewCustomizationVC : BaseViewController
@property (nonatomic,assign)int isEd;
@property (nonatomic,assign)int proId;
@property (nonatomic,  copy)NewCusEdDateBack back;
@end
