//
//  YQStatusPhotoView.m
//  清风微博
//
//  Created by tarena425 on 15/7/6.
//  Copyright (c) 2015年 ccyuqing. All rights reserved.
//

#import "YQStatusPhotoView.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
@interface YQStatusPhotoView()

@end
@implementation YQStatusPhotoView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //内容模式
        self.contentMode = UIViewContentModeScaleAspectFill;
        /*经验规律
         *1.凡是带有scale单词的，图片都会拉伸
         *2.凡是带有Aspect单词的，图片都会保持原来的宽高比，图片不会变形
         */
        //超出边框的内容都剪掉
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setPhotoStr:(NSString *)photoStr{
    _photoStr = photoStr;
    //设置图片
    [self sd_setImageWithURL:[NSURL URLWithString:_photoStr] placeholderImage:DefaultImage];
}

- (void)setPhoto:(UIImage *)photo{
    _photo = photo;
    self.image = _photo;
}

@end
