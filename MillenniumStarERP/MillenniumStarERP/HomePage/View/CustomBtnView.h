//
//  CustomBtnView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/15.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomBtnView : UIView
@property (nonatomic,weak)UILabel *titleLab;
@property (nonatomic,weak)UIButton *selBtn;
@property (nonatomic,weak)UIButton *allBtn;
+ (id)creatView;
@end
