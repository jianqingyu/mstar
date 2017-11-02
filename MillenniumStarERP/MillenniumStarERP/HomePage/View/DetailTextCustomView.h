//
//  DetailTextCustomView.h
//  MillenniumStarERP
//
//  Created by yjq on 16/12/28.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TextBack)(id model);
@interface DetailTextCustomView : UIView
@property (nonatomic,weak)UILabel *topLab;
@property (nonatomic,weak)UITextField *scanfText;
@property (nonatomic,strong)NSIndexPath *section;
@property (nonatomic,copy)TextBack textBack;
@end
