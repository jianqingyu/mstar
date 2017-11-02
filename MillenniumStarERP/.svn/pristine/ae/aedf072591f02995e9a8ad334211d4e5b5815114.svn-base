//
//  ScrollPageView.h
//  ShowProduct
//
//  Created by lin on 14-5-23.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserManagerScrollPageViewDelegate <NSObject>
-(void)didScrollPageViewChangedPage:(NSInteger)aPage;
@end

@interface UserManagerScrollPageView : UIView<UIScrollViewDelegate>
{
    NSInteger mCurrentPage;
    BOOL mNeedUseDelegate;
}
@property(retain,nonatomic)UINavigationController*navigationController;

@property (nonatomic,retain) UIScrollView *scrollView;

@property (nonatomic,retain) NSMutableArray *contentItems;

@property (nonatomic,assign) id<UserManagerScrollPageViewDelegate> delegate;
#pragma mark 添加ScrollowViewd的ContentView
-(void)setContentOfTables:(NSArray*)proidArray nav:(UINavigationController*)nav;
#pragma mark 滑动到某个页面
-(void)moveScrollowViewAthIndex:(NSInteger)index;
#pragma mark 改变TableView上面滚动栏的内容
- (id)initScrollPageView:(CGRect)frame navigation:(UINavigationController*)navigation;
@end
