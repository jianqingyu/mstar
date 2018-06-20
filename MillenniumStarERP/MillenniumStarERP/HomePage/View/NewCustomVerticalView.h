//
//  NewCustomVerticalView.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/5/16.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^NewVerDidBack)(id model);
@interface NewCustomVerticalView : UIView
@property (nonatomic,  copy)NewVerDidBack back;
- (void)setupDriInfo:(NSDictionary *)driDic;
- (void)setupData;
@end
