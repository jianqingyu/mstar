//
//  NewCustomProDetailVC.h
//  MillenniumStarERP
//
//  Created by yjq on 17/7/14.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "BaseViewController.h"
#import "NakedDriSeaListInfo.h"
typedef void (^NewEditBack)(id orderInfo);
@interface NewCustomProDetailVC : BaseViewController
@property (nonatomic,assign)int proId;
@property (nonatomic,assign)int isEdit;
@property (nonatomic,assign)BOOL isCus;
@property (nonatomic,strong)DetailTypeInfo *colorInfo;
@property (nonatomic,  copy)NewEditBack orderBack;
@property (nonatomic,strong)NakedDriSeaListInfo *seaInfo;
@end
