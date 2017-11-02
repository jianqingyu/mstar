//
//  ProductCollectionCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/6/9.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductInfo.h"
@interface ProductCollectionCell : UICollectionViewCell
@property (nonatomic,strong)ProductInfo *proInfo;
@property (nonatomic,assign)BOOL isShow;
@end
