//
//  CustomDetailView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "CustomDetailView.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "YQStatusPhotoView.h"
@implementation CustomDetailView

#define YQStatusPhotoWH (SDevWidth-40)/4
#define YQStatusPhotoMargin 8
#define YQStatusPhotoMaxCol(count) ((count==4)?4:5)

- (void)setPhotos:(NSArray *)photos{
    _photos = photos;
    NSInteger photoCount = photos.count;
    //创建缺少的imageView
    while (self.subviews.count < photoCount) {
        YQStatusPhotoView *photoView = [[YQStatusPhotoView alloc]init];
        [self addSubview:photoView];
    }
    //遍历图片,设置图片
    
    for (NSInteger i=0; i<self.subviews.count; i++) {//遍历最大的,
        YQStatusPhotoView *photoView = self.subviews[i];
        photoView.tag = i;
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseImageView:)];
        photoView.userInteractionEnabled = YES;
        [photoView addGestureRecognizer:tap];
        photoView.layer.masksToBounds = YES;
        photoView.layer.borderWidth = 1;
        if (i==0) {//如果i小于传进来图片的个数 则显示 并赋值
            photoView.layer.borderColor = MAIN_COLOR.CGColor;
        }else{//大于 则隐藏
            photoView.layer.borderColor = DefaultColor.CGColor;
        }
        if (i < photoCount) {//如果i小于传进来图片的个数 则显示 并赋值
            photoView.photoStr = photos[i];
            photoView.hidden = NO;
        }else{//大于 则隐藏
            photoView.hidden = YES;
        }
    }
}

- (void)setIdx:(NSUInteger)idx{
    [self changeImageView:idx];
}

- (void)chooseImageView:(UITapGestureRecognizer*)tap{
    [self changeImageView:tap.view.tag];
    if(_ClickDrilBlock != nil) {
        _ClickDrilBlock(tap.view.tag);
    }
}

- (void)changeImageView:(NSUInteger)idx{
    [UIView animateWithDuration:0.25 animations:^{
        for (UIView *view in self.subviews) {
            view.layer.borderColor = DefaultColor.CGColor;
        }
        UIView *chooseV = self.subviews[idx];
        chooseV.layer.borderColor = MAIN_COLOR.CGColor;
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //设置图片的尺寸和位置
    NSInteger photoCount = 0;
    if (self.photos.count) {
        photoCount = self.photos.count;
    }
    NSInteger maxCol = YQStatusPhotoMaxCol(photoCount);
    for (NSInteger i=0; i<photoCount; i++) {
        YQStatusPhotoView *photoView = self.subviews[i];
        photoView.width = YQStatusPhotoWH;
        photoView.height = YQStatusPhotoWH;
        photoView.x = (i % maxCol)*(YQStatusPhotoWH+YQStatusPhotoMargin);
        photoView.y = (i / maxCol)*(YQStatusPhotoWH+YQStatusPhotoMargin);
    }
}

+ (CGSize)sizeWithCount:(NSInteger)count{
    NSInteger macCols = YQStatusPhotoMaxCol(count);
    //列数
    NSInteger cols = (count>=macCols)?macCols:count;
    CGFloat photosW = cols *YQStatusPhotoWH + (cols-1)*YQStatusPhotoMargin;
    
    NSInteger rows = (count + macCols - 1)/macCols;
    CGFloat photosH = rows *YQStatusPhotoWH + (rows-1)*YQStatusPhotoMargin;
    return CGSizeMake(photosW, photosH);
}

@end
