//
//  KeyBoardCell.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/3/16.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyBoardModel.h"

@protocol KeyBoardCellDelegate <NSObject>

@optional
- (void)KeyBoardCellBtnClick:(NSInteger)Tag;

@end

@interface KeyBoardCell : UICollectionViewCell

@property (nonatomic,weak) id <KeyBoardCellDelegate> delegate;

@property (nonatomic,strong) UIButton * keyboardBtn;

@property (nonatomic,strong) KeyBoardModel * model;

@end
