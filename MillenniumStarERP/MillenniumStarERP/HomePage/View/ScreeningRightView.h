//
//  ScreeningRightView.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/20.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeightInfo.h"
@class CDRTranslucentSideBar;
typedef void (^ProRightViewBack)(NSDictionary *dic,BOOL isSel);
@interface ScreeningRightView : UIView
@property (nonatomic,assign)BOOL isTop;
@property (nonatomic,  copy) NSArray*goods;
@property (nonatomic,  copy) NSArray*values;
@property (nonatomic,  copy)ProRightViewBack tableBack;
@property (nonatomic,strong)NSMutableDictionary *dictB;
@property (nonatomic,strong)CDRTranslucentSideBar *rightSideBar;

@end
