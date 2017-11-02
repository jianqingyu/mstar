//
//  NakedDriLibHeadView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"NakedDriLiblistInfo.h"
typedef void (^NakedHBack)(id mess);
@interface NakedDriLibHeadView : UIView
@property (nonatomic,strong)NakedDriLiblistInfo *info;
@property (nonatomic,strong)NSDictionary *seaDic;
@property (nonatomic,  copy)NSArray *topArr;
@property (nonatomic,  copy)NakedHBack back;
- (void)setAllNoChoose;

@end
