//
//  AllListPopView.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/20.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^AllPopViewBack)(id dict);
@interface AllListPopView : UIView
@property (nonatomic,assign)int seIndex;
@property (nonatomic,copy) NSArray *productList;
@property (nonatomic,copy)AllPopViewBack popBack;
@end
