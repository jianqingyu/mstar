//
//  YQStatusPhotosView.m
//  清风微博
//
//  Created by tarena425 on 15/7/6.
//  Copyright (c) 2015年 ccyuqing. All rights reserved.
//

#import "YQStatusPhotosView.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "YQStatusPhotoView.h"

@implementation YQStatusPhotosView

#define YQStatusPhotoWH (SDevWidth-40)/3
#define YQStatusPhotoMargin 10
#define YQStatusPhotoMaxCol(count) ((count==4)?2:3)
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

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
        photoView.userInteractionEnabled = YES;
        if (i < photoCount) {//如果i小于传进来图片的个数 则显示 并赋值
            photoView.photoStr = photos[i];
            photoView.hidden = NO;
        }else{//大于 则隐藏
            photoView.hidden = YES;
        }
        photoView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                  action:@selector(lookClick:)];
        tap.view.tag = i;
        [photoView addGestureRecognizer:tap];
    }
}

- (void)setImgPhotos:(NSArray *)imgPhotos{
    _imgPhotos = imgPhotos;
    NSInteger photoCount = imgPhotos.count;
    //创建缺少的imageView
    while (self.subviews.count < photoCount) {
        YQStatusPhotoView *photoView = [[YQStatusPhotoView alloc]init];
        [self addSubview:photoView];
    }
    //遍历图片,设置图片
    for (NSInteger i=0; i<self.subviews.count; i++) {//遍历最大的,
        YQStatusPhotoView *photoView = self.subviews[i];
        photoView.tag = i;
        if (i < photoCount) {//如果i小于传进来图片的个数 则显示 并赋值
            photoView.photo = imgPhotos[i];
            photoView.hidden = NO;
        }else{//大于 则隐藏
            photoView.hidden = YES;
        }
        photoView.userInteractionEnabled = YES;
        if (i==0) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            [photoView addGestureRecognizer:tap];
        }else{
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
            [photoView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(photoView).offset(0);
                make.right.equalTo(photoView).offset(0);
                make.height.mas_equalTo(@20);
                make.width.mas_equalTo(@20);
            }];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)tapClick:(id)sender{
    if ([self.delegate respondsToSelector:@selector(YQStatusPhotos:tap:)]) {
            [self.delegate YQStatusPhotos:self tap:sender];
    }
}

- (void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(YQStatusPhotos:delete:)]) {
        [self.delegate YQStatusPhotos:self delete:btn.tag];
    }
}

- (void)lookClick:(UITapGestureRecognizer*)gesture{
    if ([self.delegate respondsToSelector:@selector(YQStatusPhotos:lookBtn:)]) {
        [self.delegate YQStatusPhotos:self lookBtn:gesture.view.tag];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //设置图片的尺寸和位置
    NSInteger photoCount = 0;
    if (self.imgPhotos.count) {
        photoCount = self.imgPhotos.count;
    }
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
