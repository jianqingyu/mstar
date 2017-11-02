//
//  SearchHeadBtnView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/20.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^sBtnBack)(id changeId);
@interface SearchHeadBtnView : UIView
- (id)initWithFrame:(CGRect)frame withArr:(NSArray *)arr;
@property (nonatomic,copy)NSArray *tArr;
@property (nonatomic,copy)sBtnBack back;
@property (nonatomic,assign)CGFloat height;
@end
