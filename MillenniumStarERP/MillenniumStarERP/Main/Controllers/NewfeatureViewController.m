//
//  NewfeatureViewController.m
//  MillenniumStar08.07
//
//  Created by yjq on 15/8/10.
//  Copyright (c) 2015年 qxzx.com. All rights reserved.
//

#import "NewfeatureViewController.h"
#import "MainTabViewController.h"
#import "LoginViewController.h"
#define YQNewfeatureCount 1
@interface NewfeatureViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIPageControl *pageControl;
@end

@implementation NewfeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, SDevWidth, SDevHeight);
    //创建scrollView
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.frame;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    //添加图片到scrollView
    CGFloat scrollW = SDevWidth;
    CGFloat scrollH = SDevHeight;
    for (int i=0; i<YQNewfeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i*scrollW;
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"iocn_bgView%d",i+1]];
        [scrollView addSubview:imageView];
        if (i == YQNewfeatureCount-1) {
            imageView.userInteractionEnabled = YES;
            [self setLastImageView:imageView];
        }
    }
    //设置scrollView的其他属性
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(YQNewfeatureCount*scrollW, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    //创建小圆点
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.centerX = scrollW*0.5;
    pageControl.centerY = scrollH*0.96;
    self.pageControl = pageControl;
    pageControl.numberOfPages = YQNewfeatureCount;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = CUSTOM_COLOR(254, 156, 54);
    [self.view addSubview:pageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    double page = scrollView.contentOffset.x/scrollView.width;
    self.pageControl.currentPage = (int)(page+0.5);
}

//创建最后一个界面
- (void)setLastImageView:(UIImageView *)imageView{
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.backgroundColor = [UIColor clearColor];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView).offset(0);
        make.bottom.equalTo(imageView).offset(0);
        make.left.equalTo(imageView).offset(0);
        make.right.equalTo(imageView).offset(0);
    }];
}

- (void)startClick{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[LoginViewController alloc]init];
}

@end
