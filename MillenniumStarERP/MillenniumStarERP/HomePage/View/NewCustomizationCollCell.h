//
//  NewCustomizationCollCell.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2017/12/12.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewCustomizationInfo.h"
@interface NewCustomizationCollCell : UICollectionViewCell
@property (nonatomic,strong)NewCustomizationInfo *info;
@property (nonatomic,assign)int number;
@property (nonatomic,  copy)NSString *drillStr;
@property (nonatomic,assign)BOOL isDef;
@end
