//
//  SettlementListHeadView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/7.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderSetmentInfo.h"
typedef void (^SetlistHeadBack)(BOOL isSel);
@interface SettlementListHeadView : UIView
@property (nonatomic,  copy)SetlistHeadBack clickBack;
@property (nonatomic,assign)BOOL isShow;
@property (nonatomic,strong)OrderSetmentInfo *headInfo;
+ (id)createHeadView;
@end
