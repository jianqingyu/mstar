//
//  NewCusBottomView.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2017/12/11.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^NewCusBtnBack)(int idex);
@interface NewCusBottomView : UIView
+ (id)creatBottomView;
@property (nonatomic, copy)NewCusBtnBack back;
@end
