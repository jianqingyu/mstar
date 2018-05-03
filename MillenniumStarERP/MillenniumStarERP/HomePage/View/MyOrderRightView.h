//
//  MyOrderRightView.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/25.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^OrderBack)(id model,BOOL isData);
@class CDRTranslucentSideBar;
@interface MyOrderRightView : UIView
@property (nonatomic,strong)CDRTranslucentSideBar *rightSideBar;
@property (nonatomic,  copy)OrderBack back;
@end
