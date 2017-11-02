//
//  SearchOrderView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/24.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SeaDateBack)(id dateInfo);
@interface SearchOrderView : UIView
@property (nonatomic,copy)NSArray *arr;
- (void)setAllBtnSele;
@property (nonatomic,copy)SeaDateBack dateBack;
@end
