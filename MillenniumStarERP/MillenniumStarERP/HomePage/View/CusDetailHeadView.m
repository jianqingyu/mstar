//
//  CusDetailHeadView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "CusDetailHeadView.h"
#import "CustomDetailView.h"
#define viewWidth SDevWidth
#define marHeight 10
#define topHeight 30
@interface CusDetailHeadView()
@property (nonatomic,strong)CustomDetailView *photosView;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *ptLab;
@end
@implementation CusDetailHeadView
+ (id)creatCustomDeHeadView{
    CusDetailHeadView *detail = [[CusDetailHeadView alloc]init];
    return detail;
}

- (id)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        
        self.photosView = [[CustomDetailView alloc]init];
        [self addSubview:self.photosView];
        
        self.titleLab = [[UILabel alloc]init];
        self.titleLab.numberOfLines = 0;
        self.titleLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.titleLab];
        
        self.ptLab = [[UILabel alloc]init];
        self.ptLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.ptLab];
    }
    return self;
}

- (void)setHeadInfo:(DetailHeadInfo *)headInfo{
    if (headInfo) {
        _headInfo = headInfo;
        if (_headInfo.pics.count>0) {
            [self setBasePhotos:_headInfo.pics];
        }else{
            [self setBasePhotos:@[@"http://appapi.fanerweb.com"]];
        }
        self.titleLab.text = _headInfo.title;
        self.ptLab.text = _headInfo.weight;
        [self setupBaseView];
    }
}

- (void)setBasePhotos:(NSArray *)arr{
    self.photosView.photos = arr;
    self.photosView.y = 10;
    self.photosView.size = [CustomDetailView sizeWithCount:arr.count];
    self.photosView.x = (viewWidth-self.photosView.size.width)/2;
    
    __weak __typeof(&*self)weakSelf = self;
    self.photosView.ClickDrilBlock = ^(NSUInteger idx) {
        if(_ClickDrilBlock != nil) {
            weakSelf.ClickDrilBlock(idx);
        }
    };
}

- (void)setupBaseView{
    CGRect rect = CGRectMake(0, 0, DevWidth/2, 999);
    rect = [self.titleLab textRectForBounds:rect limitedToNumberOfLines:0];
    
    self.titleLab.x = 10;
    self.titleLab.size = rect.size;
    self.titleLab.y = CGRectGetMaxY(self.photosView.frame)+20;
    
    self.ptLab.x = SDevWidth/2;
    self.ptLab.width = SDevWidth/2;
    self.ptLab.height = 20;
    self.ptLab.y = self.titleLab.y;
}

- (CGFloat)height{
    return CGRectGetMaxY(self.titleLab.frame)+20;
}

@end
