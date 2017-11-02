//
//  EditCustomDriView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/7/21.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ChEditDriBack)(id model);
@interface EditCustomDriView : UIView
+ (EditCustomDriView *)creatCustomView;
@property (nonatomic,  copy)NSString *number;
@property (nonatomic,strong)NSArray *infoArr;
@property (nonatomic,strong)NSMutableArray *NakedArr;
@property (nonatomic,strong)UINavigationController *supNav;
@property (nonatomic,  copy)ChEditDriBack editBack;
@end
