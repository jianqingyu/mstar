//
//  NewCustomizationView.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2017/12/7.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^NewCusDidBack)(BOOL isDef,id model);
@interface NewCustomizationView : UIView
- (id)initWithPop:(BOOL)isDef;
@property (nonatomic,  copy)NewCusDidBack back;
@property (nonatomic,assign)BOOL isH;
@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,strong)NSArray *dataNum;
@property (nonatomic,  weak)UIButton *btn;
@property (nonatomic,  copy)NSString *drillInfo;
@end
