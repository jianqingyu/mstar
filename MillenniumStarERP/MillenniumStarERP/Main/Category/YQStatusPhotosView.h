//
//  YQStatusPhotosView.h
//  清风微博
//
//  Created by tarena425 on 15/7/6.
//  Copyright (c) 2015年 ccyuqing. All rights reserved.
//  cell上面的配图相册

#import <UIKit/UIKit.h>
@class YQStatusPhotosView;
@protocol YQStatusPhotosViewDelegate <NSObject>
@optional
- (void)YQStatusPhotos:(YQStatusPhotosView*)YQStatusPhotos tap:(id)sender;
- (void)YQStatusPhotos:(YQStatusPhotosView*)YQStatusPhotos delete:(NSInteger)index;
- (void)YQStatusPhotos:(YQStatusPhotosView*)YQStatusPhotos lookBtn:(NSInteger)index;
@end

@interface YQStatusPhotosView : UIView
@property (nonatomic,strong)NSArray *photos;
@property (nonatomic,strong)NSArray *imgPhotos;
//根据图片个数设置尺寸
+ (CGSize)sizeWithCount:(NSInteger)count;
@property (nonatomic,assign)id<YQStatusPhotosViewDelegate>delegate;
@end
