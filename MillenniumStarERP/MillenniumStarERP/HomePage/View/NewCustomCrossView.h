//
//  NewCustomCrossView.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/5/10.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^crossBack)(int type,BOOL isItem);
@interface NewCustomCrossView : UIView
@property (nonatomic, copy)crossBack back;
@property (nonatomic, weak)UIView *croBtmView;
- (void)setSmallData;
- (void)setBottomData;
- (void)setDriInfo:(NSDictionary *)dic;

@end
