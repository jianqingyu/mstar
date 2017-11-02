//
//  MenuHrizontal.h
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import <UIKit/UIKit.h>

#define NOMALKEY   @"normalKey"
#define HEIGHTKEY  @"helightKey"
#define TITLEKEY   @"titleKey"
#define TITLEWIDTH @"titleWidth"
#define TOTALWIDTH @"totalWidth"

@protocol UserManagerMenuHrizontalDelegate <NSObject>

@optional
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex;
@end
@interface UserManagerMenuHrizontal : UIView{
    NSMutableArray        *mButtonArray;
    NSMutableArray        *mItemInfoArray;
    NSMutableArray        *mLabArray;
    UIScrollView          *mScrollView;
    float                 mTotalWidth;
}
@property (nonatomic,strong)NSArray *imgArr;
@property (nonatomic,assign) id <UserManagerMenuHrizontalDelegate> delegate;

#pragma mark 初始化菜单
- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)aItemsArray;

#pragma mark 选中某个button
-(void)clickButtonAtIndex:(NSInteger)aIndex;

#pragma mark 改变第几个button为选中状态，不发送delegate
-(void)changeButtonStateAtIndex:(NSInteger)aIndex;

@end
