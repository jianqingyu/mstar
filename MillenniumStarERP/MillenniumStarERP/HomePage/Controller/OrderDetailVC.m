//
//  OrderDetailVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/10/8.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "OrderDetailVC.h"
#import "OrderHeadTableCell.h"
#import "OrderBottomTableCell.h"
#import "OrderHeadView.h"
@interface OrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy) NSArray *list;
@end

@implementation OrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单信息";
    self.list = @[@{@"lab1":@"条码",@"lab2":@"3526253"},
                  @{@"lab1":@"重量",@"lab2":@"4.3G"},
                  @{@"lab1":@"款号",@"lab2":@"VB15"},
                  @{@"lab1":@"手寸",@"lab2":@"11"},
                  @{@"lab1":@"成色",@"lab2":@"MVU"},
                  @{@"lab1":@"生产成色",@"lab2":@"MVU"}];
    [self setupHeadView];
}

- (void)setupHeadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 100)];
    OrderHeadView *hView = [OrderHeadView view];
    [headView addSubview:hView];
    [hView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView).offset(0);
        make.left.equalTo(headView).offset(0);
        make.right.equalTo(headView).offset(0);
        make.bottom.equalTo(headView).offset(0);
    }];
    self.tableView.tableHeaderView = headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 215;
    if (indexPath.section==0) {
        NSInteger total = self.list.count;
        NSInteger rows = (total / 2) + ((total % 2) > 0 ? 1 : 0);
        height = (float)FROWHEIHT * rows + FROWSPACE * (rows + 1)+38;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        OrderHeadTableCell *cell = [OrderHeadTableCell cellWithTableView:tableView];
        cell.list = self.list;
        return cell;
    }else{
        OrderBottomTableCell *cell = [OrderBottomTableCell cellWithTableView:tableView];
        return cell;
    }
}

@end
