//
//  ChooseNakedDriVC.h
//  MillenniumStarERP
//
//  Created by yjq on 17/7/20.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^chooseDriBack)(id model);
@interface ChooseNakedDriVC : BaseViewController
@property (nonatomic,assign)int isCan;
@property (nonatomic,strong)NSDictionary *seaDic;
@property (nonatomic,  copy)NSString *number;
@property (nonatomic,  copy)NSArray *dataArr;
@property (nonatomic,  copy)chooseDriBack eidtBack;
@property (nonatomic,strong)NSArray *infoArr;
@end
