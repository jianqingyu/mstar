//
//  CustomTopBtn.h
//  MillenniumStarERP
//
//  Created by yjq on 17/7/26.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTopBtn : UIView
+ (CustomTopBtn *)creatCustomView;
@property (nonatomic,weak)UIButton *sBtn;
@property (nonatomic,weak)UIButton *bBtn;
@property (nonatomic,weak)UILabel *titleLab;
@end
