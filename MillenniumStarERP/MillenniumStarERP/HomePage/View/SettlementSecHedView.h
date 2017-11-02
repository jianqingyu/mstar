//
//  SettlementSecHedView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/6.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettlementListInfo.h"
@interface SettlementSecHedView : UIView
+ (SettlementSecHedView *)creatView;
@property (nonatomic,strong)SettlementListInfo *secInfo;
@end
