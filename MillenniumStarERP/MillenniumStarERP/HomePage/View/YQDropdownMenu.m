//
//  YQDropdownMenu.m
//  YQ微博
//
//  Created by tarena425 on 15/7/1.
//  Copyright (c) 2015年 ccyuqing. All rights reserved.
//

#import "YQDropdownMenu.h"
#import "UIView+Extension.h"
@interface YQDropdownMenu()
@property (nonatomic,weak)UIImageView *containerView;
@end
@implementation YQDropdownMenu

- (UIImageView *)containerView{
    if (!_containerView) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"icon_qp"];
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        _containerView = imageView;
    }
    return _containerView;
}

+ (instancetype)menu{
    return [[self alloc]init];
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)showFrom:(UIView *)from{
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    self.frame = window.bounds;
    //默认情况下,frame是以父控件左上角为坐标原点
    CGRect newFrame = [from convertRect:from.bounds toView:window];
    self.containerView.centerX = CGRectGetMidX(newFrame);
    self.containerView.y = CGRectGetMaxY(newFrame);
    //通知外界，自己被创建了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        [self.delegate dropdownMenuDidShow:self];
    }
}

- (void)dismiss{
    [self removeFromSuperview];
    //通知外界，自己被销毁了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidDismiss:)]) {
        [self.delegate dropdownMenuDidDismiss:self];
    }
}

- (void)setContent:(UIView *)content{
    _content = content;
    content.x = 10;
    content.y = 20;
    self.containerView.width = CGRectGetMaxX(content.frame)+10;
    self.containerView.height = CGRectGetMaxY(content.frame)+10;
    [self.containerView addSubview:content];
}

- (void)setController:(UIViewController *)controller{
    _controller = controller;
    self.content = controller.view;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

@end
