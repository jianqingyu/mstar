//
//  ProductPopView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/8.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ProductPopView.h"
#import "PopViewSingleCell.h"
#import "PopViewMultipleCell.h"
@interface ProductPopView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *productList;
@property (nonatomic, assign) NSUInteger index;
@end
@implementation ProductPopView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc]initWithFrame:
                       CGRectMake(0, 0, SDevWidth, 200) style:UITableViewStyleGrouped];
        self.productList = @[@[@"全部",@"热门",@"浏览历史",@"畅销商品"],@[@"全部",@"热门",@"浏览历史",@"畅销商品"],@[@"全部",@"热门",@"浏览历史",@"畅销商品"]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        [self setupFootView];
    }
    return self;
}

- (void)setupFootView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 60)];
    UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    subBtn.backgroundColor = MAIN_COLOR;
    subBtn.layer.cornerRadius = 5;
    subBtn.layer.masksToBounds = YES;
    [subBtn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    subBtn.frame = CGRectMake(20, 10, SDevWidth-40, 40);
    [footView addSubview:subBtn];
    [subBtn setTitle:@"确定" forState:UIControlStateNormal];
    _tableView.tableFooterView = footView;
}

- (void)confirmClick:(id)sender{
    [self removeFromSuperview];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.productList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    if (self.productList.count)
    {
        PopViewSingleCell *cell = (PopViewSingleCell *)[self tableView:tableView
                                           cellForRowAtIndexPath:indexPath];
        height = [cell.contentView systemLayoutSizeFittingSize:
                  UILayoutFittingCompressedSize].height + 1;
    }
    return height;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    CGFloat height = 10.0f;
//    if (tableView.tag==100) {
//        if (section==0) {
//            height = 1.0f;
//        }else if (section==self.productList.count+1){
//            height = 10.0f;
//        }else{
//            height = 0.0001f;
//        }
//    }
//    return height;
//}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *list = self.productList[indexPath.section];
    if (indexPath.section==0) {
        PopViewSingleCell *tabCell = [PopViewSingleCell cellWithTableView:tableView];
        [tabCell setCellWithInfo:list forInPath:indexPath atIdx:_index];
        tabCell.tagView.didClickTagAtIndex = ^(NSUInteger index,NSUInteger section){
            _index = index;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationNone];
        };
        return tabCell;
    }else{
        PopViewMultipleCell *mulCell = [PopViewMultipleCell cellWithTableView:tableView];
        [mulCell setCellWithInfo:list forInPath:indexPath];
        mulCell.tagView.didClickTagAtIndex = ^(NSUInteger index,NSUInteger section,BOOL isSed){
        };
        return mulCell;
    }
}

@end
