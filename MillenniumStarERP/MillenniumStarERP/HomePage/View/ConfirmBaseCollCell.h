//
//  ConfirmBaseCollCell.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/17.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListInfo.h"
@class ConfirmBaseCollCell;
@protocol ConfirmBaseCollCellDelegate <NSObject>
- (void)baseCellClick:(ConfirmBaseCollCell *)cell andIndex:(NSInteger)index;
@end
@interface ConfirmBaseCollCell : UICollectionViewCell
@property (nonatomic,strong)OrderListInfo *listInfo;
@property (nonatomic,assign)BOOL isBtnHidden;
@property (nonatomic,assign)BOOL isTopHidden;
@property (nonatomic,  weak)id<ConfirmBaseCollCellDelegate> delegate;
@end
