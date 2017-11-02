//
//  ETFoursquareImages.m
//  ETFoursquareImagesDemo
//
//  Created by Eugene Trapeznikov on 11/21/13.
//  Copyright (c) 2013 Eugene Trapeznikov. All rights reserved.
//

#import "ETFoursquareImages.h"
#import "UIImageView+WebCache.h"

@implementation ETFoursquareImages

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollView.bounces = YES;
        self.scrollView.alwaysBounceVertical = YES;
        self.scrollView.delegate = self;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        [self.scrollView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.scrollView];
        
        self.pageControlHeight = 18;
        
        pageControlIsChangingPage = NO;
        self.imageViewArray = [NSMutableArray array];
    }
    return self;
}

-(void)setImages:(NSArray *)_imagesArray{
    if (_imagesArray.count != 0) {
        //images
        imagesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, imagesScrollStart, self.frame.size.width, imagesHeight)];
        imagesScrollView.backgroundColor = [UIColor whiteColor];
        imagesScrollView.canCancelContentTouches = NO;
        imagesScrollView.showsHorizontalScrollIndicator = NO;
        imagesScrollView.showsVerticalScrollIndicator = NO;
        imagesScrollView.bounces = NO;
        imagesScrollView.delegate = self;
        imagesScrollView.clipsToBounds = YES;
        imagesScrollView.scrollEnabled = YES;
        imagesScrollView.pagingEnabled = YES;
        
        for (int i=0;i<_imagesArray.count;i++){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, imagesHeight)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[_imagesArray objectAtIndex:i]] placeholderImage:DefaultImage];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageGesture:)];
            tapGesture.view.tag = i;
            [imageView addGestureRecognizer:tapGesture];
            [self.imageViewArray addObject:imageView];
            [imagesScrollView addSubview:imageView];
        }
        imagesScrollView.contentSize = CGSizeMake(_imagesArray.count * self.frame.size.width, imagesHeight);
        [self.scrollView addSubview:imagesScrollView];
        
        //  Page Control
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, imagesHeight- self.pageControlHeight, self.frame.size.width, self.pageControlHeight)];
        self.pageControl.numberOfPages = _imagesArray.count;
        self.pageControl.currentPage = 0;
        self.pageControl.hidesForSinglePage = YES;
        [self.pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [self.pageControl setCurrentPageIndicatorTintColor:MAIN_COLOR];
        [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:self.pageControl];
        
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, imagesHeight, self.frame.size.width, self.frame.size.height - imagesHeight)];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:self.bottomView];
    }
}

- (void)setImagesHeight:(int)_imagesHeight{
    imagesHeight = _imagesHeight;
    imagesScrollStart = -(self.frame.size.width - imagesHeight)/2;
    imagesScrollStart = 0;
    scrollingKoef = 0.3*imagesHeight/80.0;
}

#pragma mark - Actions
- (void)changePage:(UIPageControl *)pageControl {
    CGRect imagesFrame = imagesScrollView.frame;
    imagesFrame.origin.x = imagesFrame.size.width * pageControl.currentPage;
    imagesFrame.origin.y = 0;
    [imagesScrollView scrollRectToVisible:imagesFrame animated:YES];
    pageControlIsChangingPage = YES;
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.scrollView){
        return;
    }
    
    if (pageControlIsChangingPage) {
        return;
    }
    CGFloat pageWidth = imagesScrollView.frame.size.width;
    NSUInteger page = floor((imagesScrollView.contentOffset.x - pageWidth / 2.0f) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView {
    pageControlIsChangingPage = NO;
}

- (void)tapImageGesture:(UITapGestureRecognizer*)gesture
{
    if ([self.delegate respondsToSelector:@selector(imageTapGestureWithIndex:)]) {
        [self.delegate imageTapGestureWithIndex:(int)self.pageControl.currentPage];
    }
}

@end
