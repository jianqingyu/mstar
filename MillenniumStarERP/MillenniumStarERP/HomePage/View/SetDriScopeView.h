//
//  SetDriScopeView.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/9.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetDriInfo.h"
@interface SetDriScopeView : UIView
typedef void (^SerDriClick)(BOOL isAdd,id model);
+ (id)creatSetDriView;
@property (nonatomic,assign)int index;
@property (nonatomic,  copy)SerDriClick back;
@property (nonatomic,strong)SetDriInfo *info;
@end
