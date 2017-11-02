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
@end
@implementation AllListPopView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = BordColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.left.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.height.mas_equalTo(@0.5);
        }];
        
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0);
            make.top.equalTo(self).offset(0.5);
            make.right.equalTo(self).offset(0);
            make.height.mas_equalTo(@0);
        }];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        // 9.0以上才有这个属性，针对ipad
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0){
            _tableView.cellLayoutMarginsFollowReadableWidth = NO;
        }
    }
    return self;
}

- (void)setProductList:(NSArray *)productList{
    if (productList.count>0) {
        _productList = productList;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(productList.count*44));
        }];
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
