//
//  KeyBoardView.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/3/16.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyBoardCell.h"
#import "CustomFlowLayout.h"
@class KeyBoardView;
//1.定义协议 命名:类名+Delegate
@protocol KeyBoardViewDelegate <NSObject>
//方法的参数:第一参数是委托方自己,后面的参数可以为委托方发给代理方的辅助信息
- (void)btnClick:(KeyBoardView *)headView andIndex:(NSInteger)index;
@end
@interface KeyBoardView : UIView <UICollectionViewDelegate,UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,KeyBoardCellDelegate>
{
    BOOL isUp;
}

@property (nonatomic,strong) UICollectionView * topView;

@property (nonatomic,strong) UICollectionView * middleView;

@property (nonatomic,strong) UICollectionView * bottomView;

@property (nonatomic,strong) UICollectionView * symbolView;

@property (nonatomic,strong) UIView * inputSource;

@property (nonatomic,strong) UIButton * clearBtn;

@property (nonatomic,strong) UIButton * upBtn;

@property (nonatomic,strong) UIView * btnView;

@property (nonatomic,strong) NSMutableArray * modelArray;

@property (nonatomic,strong) NSArray * letterArray;

@property (nonatomic,  weak) id<KeyBoardViewDelegate> delegate;

@end
