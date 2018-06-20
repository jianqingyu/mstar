//
//  NewPerCustomizeView.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/5/14.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PerCusBack)(id model);
@interface NewPerCustomizeView : UIView
@property (nonatomic,strong)NSDictionary *homeData;
@property (nonatomic,  copy)NSArray *cusArr;
@property (nonatomic,  copy)PerCusBack back;
- (void)setupDriInfo:(NSDictionary *)driDic;
- (void)setupData;

@end
