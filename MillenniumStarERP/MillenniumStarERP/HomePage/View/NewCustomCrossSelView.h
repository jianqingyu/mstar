//
//  NewCustomCrossSelView.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/5/14.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^crossSelBack)(BOOL isSel,id model);
@interface NewCustomCrossSelView : UIView
@property (nonatomic,  copy)crossSelBack back;
@property (nonatomic,  copy)NSArray *data;
@property (nonatomic,  copy)NSString *str;
@end
