//
//  ProgressListView.h
//  MillenniumStarERP
//
//  Created by yjq on 16/12/22.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressListView : UIView
@property (nonatomic,weak)UIView *oneView;
@property (nonatomic,weak)UIView *secView;
@property (nonatomic,assign)float progress;
@property (nonatomic,weak)UILabel *titleLab;
@end
