//
//  MenuHrizontal.h
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserManagerMenuHrizontalDelegate <NSObject>

@optional
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex;
@end
@interface UserManagerMenuHrizontal : UIView{
    NSMutableArray        *mButtonArray;
    NSMutableArray        *mItemInfoArray;
    NSMutableArray        *mLabArray;
}
@property (nonatomic,strong)NSArray *imgArr;
@property (nonatomic,assign) id <UserManagerMenuHrizontalDelegate> delegate;
@property (nonatomic,strong) UIScrollView*mScrollView;
#pragma mark 初始化菜单
- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)aItemsArray;

#pragma mark 选中某个button
-(void)clickButtonAtIndex:(NSInteger)aIndex;

#pragma mark 改变第几个button为选中状态，不发送delegate
-(void)changeButtonStateAtIndex:(NSInteger)aIndex;

@end
