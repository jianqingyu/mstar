//
//  FinishedProInfoVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/26.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "FinishedProInfoVC.h"
#import "FinishedProFCell.h"
#import "ETFoursquareImages.h"
#import "FinishedFootView.h"
@interface FinishedProInfoVC ()<UITableViewDelegate,UITableViewDataSource,imageTapDelegate,MWPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy) NSArray *photos;
@property (nonatomic,copy) NSArray *images;
@property (nonatomic,copy) NSArray *list;
@end

@implementation FinishedProInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成品信息";
    self.images = @[@"http://appapi.fanerweb.com/images/imageForApi/functions/order.png",@"http://appapi.fanerweb.com/images/imageForApi/functions/product.png",@"http://appapi.fanerweb.com/images/imageForApi/functions/order.png",@"http://appapi.fanerweb.com/images/imageForApi/functions/product.png"];
    self.list = @[@{@"lab1":@"条码",@"lab2":@"3526253"},
                  @{@"lab1":@"重量",@"lab2":@"4.3G"},
                  @{@"lab1":@"款号",@"lab2":@"VB15"},
                  @{@"lab1":@"手寸",@"lab2":@"11"},
                  @{@"lab1":@"成色",@"lab2":@"MVU"},
                  @{@"lab1":@"生产成色",@"lab2":@"MVU"}];
    [self setHeadViewAndFootView];
}

- (void)setHeadViewAndFootView{
    CGRect frame = CGRectMake(0, 0, SDevWidth, SDevHeight*0.4);
    ETFoursquareImages *headView = [[ETFoursquareImages alloc]initWithFrame:frame];
    [headView setImagesHeight:SDevHeight*0.4];
    headView.delegate = self;
    [headView setImages:self.images];
    self.tableView.tableHeaderView = headView;
    
    NSInteger total = self.list.count;
    NSInteger rows = (total / 2) + ((total % 2) > 0 ? 1 : 0);
    CGFloat height = (float)FROWHEIHT * rows + FROWSPACE * (rows + 1);
    FinishedFootView *footView = [FinishedFootView new];
    footView.frame = CGRectMake(0, 0, SDevWidth, height+38);
    footView.list = self.list;
    self.tableView.tableFooterView = footView;
}

#pragma mark - imageTapDelegate
- (void)imageTapGestureWithIndex:(int)index{
    //网络图片展示
    [self networkImageShow:index];
}

- (void)networkImageShow:(int)index{
    
    NSMutableArray *photos = [NSMutableArray array];
    for (NSString *str in self.images) {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:str]];
        [photos addObject:photo];
    }
    self.photos = [photos copy];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:YES];
}
#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser
                photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 225;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FinishedProFCell *cell = [FinishedProFCell cellWithTableView:tableView];
    return cell;
}

@end
