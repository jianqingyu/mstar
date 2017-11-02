//
//  ScrollPageView.m
//  ShowProduct
//
//  Created by JIMU on 14-8-29.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import "UserManagerScrollPageView.h"
#import "UserManagerTableView.h"
@implementation UserManagerScrollPageView

- (id)initScrollPageView:(CGRect)frame navigation:(UINavigationController*)navigation{
    self = [super initWithFrame:frame];
    if (self) {
        mNeedUseDelegate = YES;
        [self commInit];
    }
    self.navigationController = navigation;
    return self;
}

- (void)commInit{
    if (_contentItems == nil) {
        _contentItems = [[NSMutableArray alloc] init];
    }
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    [self addSubview:_scrollView];
}

#pragma mark - 其他辅助功能
#pragma mark 添加ScrollowViewd的ContentView
- (void)setContentOfTables:(NSArray *)proidArr andId:(id)idTab{
    proArr = proidArr;
    UIView *lastView = nil;
    for (int i=0;i<proArr.count;i++) {
        Class c;
        if ([idTab isKindOfClass:[NSArray class]]) {
            c = NSClassFromString(idTab[i]);
        }else{
            c = NSClassFromString(idTab);
        }
        UIView *contentView = [[c alloc]initWithFrame:CGRectZero];
        [contentView setValue:self.navigationController forKey:@"superNav"];
        [_scrollView addSubview:contentView];
        [_contentItems addObject:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_scrollView).offset(0);
            make.bottom.equalTo(_scrollView).offset(0);
            make.width.equalTo(_scrollView);
            make.height.equalTo(_scrollView);
            if (lastView) {
                make.left.mas_equalTo(lastView.mas_right).with.offset(0);
            } else {
                make.left.mas_equalTo(_scrollView).offset(0);
            }
        }];
        lastView = contentView;
    }
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.right.mas_equalTo(lastView.mas_right).offset(0);
    }];
}

#pragma mark 移动ScrollView到某个页面
- (void)moveScrollowViewAthIndex:(NSInteger)index{
    if (index<_contentItems.count) {
        UIView *contentView = _contentItems[index];
        [contentView setValue:proArr[index] forKey:@"dict"];
    }
    mNeedUseDelegate = NO;
    CGRect vMoveRect = CGRectMake(self.width *index, 0, SDevWidth, SDevHeight);
    [_scrollView scrollRectToVisible:vMoveRect animated:YES];
    mCurrentPage = index;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)]) {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
}

- (void)moveScrollowViewToFirst{
    mNeedUseDelegate = NO;
    _scrollView.contentOffset = CGPointMake(0, 0);
    mCurrentPage = 0;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)]) {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    mNeedUseDelegate = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = (_scrollView.contentOffset.x+self.width/2.0)/self.width;
    if (mCurrentPage == page) {
        return;
    }
    if (page<_contentItems.count) {
        UIView *contentView = _contentItems[page];
        [contentView setValue:proArr[page] forKey:@"dict"];
    }
    mCurrentPage= page;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)] && mNeedUseDelegate) {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
}

@end
