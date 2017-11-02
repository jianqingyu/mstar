//
//  YQTagView.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/12.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTag.h"
@interface YQTagView : UIView

@property (nonatomic) UIEdgeInsets padding;
@property (nonatomic) int lineSpace;
@property (nonatomic) CGFloat insets;
@property (nonatomic) CGFloat preferredMaxLayoutWidth;
@property (nonatomic) BOOL singleLine;
@property (nonatomic) NSUInteger section;
- (void)addTag:(SKTag *)tag;
- (void)insertTag:(SKTag *)tag atIndex:(NSUInteger)index;
- (void)removeTag:(SKTag *)tag;
- (void)removeTagAtIndex:(NSUInteger)index;
- (void)removeAllTags;

@property (nonatomic, copy) void (^didClickTagAtIndex)(NSUInteger index,NSUInteger section,BOOL isSed);
@end
