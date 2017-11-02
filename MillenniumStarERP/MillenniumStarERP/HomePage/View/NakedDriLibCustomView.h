//
//  NakedDriLibCustomView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/7/25.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedDriLibCustomView : UIView
+ (NakedDriLibCustomView *)creatCustomView;
@property (nonatomic,assign)BOOL isCus;
@property (nonatomic,assign)BOOL isSel;
@property (nonatomic,assign)BOOL isPro;
@property (nonatomic,strong)UINavigationController *supNav;
@property (nonatomic,strong)NSDictionary *seaDic;
@end
