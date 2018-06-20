//
//  NewCustomItemView.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/5/11.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewCustomizationInfo.h"
typedef void (^itemBack)(id model);
@interface NewCustomItemView : UIView
@property (nonatomic,  copy)itemBack back;
@property (nonatomic,strong)NewCustomizationInfo *info;
@property (nonatomic,assign)int number;
@end
