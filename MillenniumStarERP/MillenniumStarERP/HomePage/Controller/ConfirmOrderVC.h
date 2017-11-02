//
//  ConfirmOrderVC.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^ EditOrderBack)(id orderInfo);
typedef void (^ EditBoolBack)(BOOL isDel);
@interface ConfirmOrderVC : BaseViewController
@property (nonatomic,assign)BOOL isSel;
@property (nonatomic,assign)BOOL isOrd;
@property (nonatomic,assign)int editId;
@property (nonatomic,copy)EditOrderBack orderBack;
@property (nonatomic,copy)EditBoolBack boolBack;
@end
