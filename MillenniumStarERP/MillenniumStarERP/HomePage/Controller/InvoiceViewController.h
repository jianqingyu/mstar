//
//  InvoiceViewController.h
//  MillenniumStarERP
//
//  Created by yjq on 16/12/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "BaseViewController.h"
#import "DetailTypeInfo.h"
typedef void (^InvoiceBack)(id object);
@interface InvoiceViewController : BaseViewController
@property (nonatomic,copy)InvoiceBack invoBack;
@property (nonatomic,strong)DetailTypeInfo *invoInfo;
@property (nonatomic,assign)BOOL isStone;
@end
