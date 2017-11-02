//
//  ProductionDetailView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/16.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "ProductionDetailView.h"
#import "ConfirmOrdCell.h"
#import "OrderListInfo.h"
#import "ProduceHeadView.h"
#import "ProduceOrderInfo.h"
#import "ProgressOrderVc.h"
@interface ProductionDetailView()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_mTableView;
    NSDictionary *_baseDic;
}
@end
@implementation ProductionDetailView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTableView];
        [self setupBottomBtn];
    }
    return self;
}

- (void)setupTableView{
    _mTableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
//    _mTableView.rowHeight = UITableViewAutomaticDimension;
//    _mTableView.estimatedRowHeight = 90;
    [self addSubview:_mTableView];
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(-44);
    }];
}

- (void)setTableHeadView:(ProduceOrderInfo *)info{
    ProduceHeadView *headView = [ProduceHeadView view];
    headView.orderInfo = info;
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, headView.high+10)];
    headV.backgroundColor = DefaultColor;
    headView.frame = CGRectMake(0, 10, SDevWidth, headView.high);
    [headV addSubview:headView];
    _mTableView.tableHeaderView = headV;
}

- (void)setupBottomBtn{
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setTitle:@"查看审核前状态" forState:UIControlStateNormal];
    [changeBtn setTitle:@"查看审核后状态" forState:UIControlStateSelected];
    [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    changeBtn.backgroundColor = MAIN_COLOR;
    [changeBtn addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:changeBtn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"查看进度" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = CUSTOM_COLOR(242, 140, 42);
    [nextBtn addTarget:self action:@selector(lookProgress:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextBtn];

    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(nextBtn.mas_left).with.offset(0);
        make.height.mas_equalTo(@44);
        make.width.equalTo(nextBtn);
    }];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.left.equalTo(changeBtn.mas_right).with.offset(0);
        make.height.mas_equalTo(@44);
        make.width.equalTo(changeBtn);
    }];
}

- (void)setDict:(NSDictionary *)dict{
    if (dict) {
        _dict = dict;
        if (_baseDic.count==0) {
            _baseDic = _dict;
        }
        [_mTableView reloadData];
        [self setTableHeadView:_dict[@"orderInfo"]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dict[@"orderList"]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConfirmOrdCell *conCell = [ConfirmOrdCell cellWithTableView:tableView];
    conCell.isTopHidden = YES;
    OrderListInfo *listInfo;
    NSArray *arr = _dict[@"orderList"];
    if (indexPath.section<arr.count) {
        listInfo = arr[indexPath.section];
    }
    conCell.listInfo = listInfo;
    return conCell;
}

- (void)bottomClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.dict[@"isSearch"]intValue]==1) {
        if (sender.selected) {
            [self loadOrderData];
        }else{
            self.dict = _baseDic;
        }
        return;
    }
    if (self.back) {
        self.back(sender.selected);
    }
}

- (void)loadOrderData{
    NSMutableDictionary *mutDic = [NSMutableDictionary new];
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *url = [NSString stringWithFormat:@"%@ModelOrderProduceDetailHistoryPageForSearch",baseUrl];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"orderNum"] = self.dict[@"orderNum"];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0&&[YQObjectBool boolForObject:response.data]) {
            if ([YQObjectBool boolForObject:response.data[@"modelList"]]) {
                NSArray *arr = [OrderListInfo objectArrayWithKeyValuesArray:response.data[@"modelList"]];
                mutDic[@"orderList"] = arr;
            }
            if ([YQObjectBool boolForObject:response.data[@"orderInfo"]]) {
                ProduceOrderInfo *info = [ProduceOrderInfo
                                          objectWithKeyValues:response.data[@"orderInfo"]];
                mutDic[@"orderInfo"] = info;
            }
            mutDic[@"orderNum"] = self.dict[@"orderNum"];
            mutDic[@"isSearch"] = @1;
            self.dict = mutDic.copy;
        }
    } requestURL:url params:params];
}

- (void)lookProgress:(id)sender {
    NSString *class = @"ProgressOrderVc";
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    //如果没有则注册一个类
    if (!newClass) {
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        objc_registerClassPair(newClass);
    }
    // 创建对象
    id instance = [[newClass alloc] init];
    [instance setValue:self.dict[@"orderNum"] forKey:@"orderNum"];
    if ([self.dict[@"isSearch"]intValue]==1) {
        [instance setValue:self.dict[@"isSearch"] forKey:@"isSea"];
    }
    [self.superNav pushViewController:instance animated:YES];
}

@end
