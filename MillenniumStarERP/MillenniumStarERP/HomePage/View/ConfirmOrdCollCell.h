//
//  ConfirmOrdCollCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/8/7.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListInfo.h"
@class ConfirmOrdCollCell;
@protocol ConfirmOrdCollCellDelegate <NSObject>
- (void)btnCellClick:(ConfirmOrdCollCell *)cell andIndex:(NSInteger)index;
@end
@interface ConfirmOrdCollCell : UICollectionViewCell
@property (nonatomic,strong)OrderListInfo *listInfo;
@property (nonatomic,assign)BOOL isBtnHidden;
@property (nonatomic,assign)BOOL isTopHidden;
@property (nonatomic,  weak)id<ConfirmOrdCollCellDelegate> delegate;
@end
