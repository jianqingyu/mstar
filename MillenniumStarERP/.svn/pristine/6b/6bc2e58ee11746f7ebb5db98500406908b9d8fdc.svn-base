//
//  ProductListHeadBtn.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/8.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#define NOMALKEY   @"normalKey"
#define HEIGHTKEY  @"helightKey"
#define TITLEKEY   @"titleKey"
#define TITLEWIDTH @"titleWidth"
#define TOTALWIDTH @"totalWidth"
@protocol ProductListHeadBtnDelegate <NSObject>
@optional
- (void)didMenuBtnClickedButtonAtIndex:(NSInteger)aIndex;
@end

@interface ProductListHeadBtn : UIView{
    NSMutableArray        *mButtonArray;
    NSMutableArray        *mItemInfoArray;
    NSMutableArray        *mLabArray;
    UIScrollView          *mScrollView;
    float                 mTotalWidth;
}

@property (nonatomic,assign) id <ProductListHeadBtnDelegate> delegate;
@property (nonatomic,copy)NSString *lineImg;
#pragma mark 初始化菜单
- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)aItemsArray;

#pragma mark 选中某个button
- (void)clickButtonAtIndex:(NSInteger)aIndex;

#pragma mark 改变第几个button为选中状态，不发送delegate
- (void)changeButtonStateAtIndex:(NSInteger)aIndex;

@end
