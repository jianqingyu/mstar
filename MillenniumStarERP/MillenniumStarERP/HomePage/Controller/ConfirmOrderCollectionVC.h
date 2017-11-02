//
//  ConfirmOrderCollectionVC.h
//  MillenniumStarERP
//
//  Created by yjq on 17/8/7.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^ EditOrdCoBack)(id orderInfo);
typedef void (^ EditBoolCoBack)(BOOL isDel);
@interface ConfirmOrderCollectionVC : BaseViewController
@property (nonatomic,copy)EditOrdCoBack orderBack;
@property (nonatomic,copy)EditBoolCoBack boolBack;
@property (nonatomic,assign)int editId;
@end
