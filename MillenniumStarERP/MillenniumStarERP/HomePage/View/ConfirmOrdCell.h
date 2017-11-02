//
//  ConfirmOrdCell.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListInfo.h"
@class ConfirmOrdCell;
@protocol ConfirmOrdCellDelegate <NSObject>
- (void)btnCellClick:(ConfirmOrdCell *)headView andIndex:(NSInteger)index;
@end

@interface ConfirmOrdCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)OrderListInfo *listInfo;
@property (nonatomic,assign)BOOL isBtnHidden;
@property (nonatomic,assign)BOOL isTopHidden;
@property (nonatomic,assign)BOOL isShow;
@property (nonatomic,  weak)id<ConfirmOrdCellDelegate> delegate;
@end
