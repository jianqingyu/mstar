//
//  AllListPopView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/20.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "AllListPopView.h"
#import "DetailTypeInfo.h"
@interface AllListPopView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,weak)UIView *backView;
@property (nonatomic,assign)int seIndex;
@end
@implementation AllListPopView

- (id)initWithFrame:(CGRect)frame andFloat:(CGFloat)tableX{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        
        UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, SDevWidth, 0)];
        back.backgroundColor = [UIColor whiteColor];
        [self addSubview:back];
        self.backView = back;
        
        _tableView = [[UITableView alloc]initWithFrame:
                      CGRectMake(tableX-10, 0, SDevWidth-tableX-10, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [back addSubview:_tableView];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return self;
}

- (void)setProductList:(NSArray *)productList{
    if (productList.count>0) {
        _productList = productList;
        self.tableView.height = _productList.count*44;
        self.backView.height = _productList.count*44;
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tabCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!tabCell) {
        tabCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        tabCell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    DetailTypeInfo *detail = self.productList[indexPath.row];
    tabCell.textLabel.text = detail.title;
    if (indexPath.row==self.seIndex) {
        tabCell.textLabel.textColor = [UIColor redColor];
    }else{
        tabCell.textLabel.textColor = [UIColor blackColor];
    }
    return tabCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.seIndex = (int)indexPath.row;
    [self.tableView reloadData];
    DetailTypeInfo *detail = self.productList[indexPath.row];
    if (self.popBack) {
        if (detail.title.length>2) {
            detail.title = [detail.title substringFromIndex:detail.title.length-2];
        }
        self.popBack(@{@(detail.id):detail.title});
    }
    [self removeFromSuperview];
}

@end
