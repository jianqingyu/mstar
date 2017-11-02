//
//  ProductionDetailView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/16.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ProDeBack)(BOOL isSel);
@interface ProductionDetailView : UIView
@property(strong,nonatomic)NSDictionary *dict;
@property(strong,nonatomic)UINavigationController*superNav;
@property (nonatomic, copy)ProDeBack back;
@end
