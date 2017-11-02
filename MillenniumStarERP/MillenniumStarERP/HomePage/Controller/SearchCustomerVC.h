//
//  SearchCustomerVC.h
//  MillenniumStarERP
//
//  Created by yjq on 16/10/25.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^SearcherBack)(id model);
@interface SearchCustomerVC : BaseViewController
@property (nonatomic,copy)NSString *searchMes;
@property (nonatomic,copy)SearcherBack back;
@end
