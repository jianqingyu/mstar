//
//  NakedDriOrderListView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriOrderListView.h"
#import "NakedDriOListInfo.h"
#import "NakedDriAllListCell.h"
#import "NakedDriDetailOrderVc.h"
#import "PayViewController.h"
@interface NakedDriOrderListView()<UITableViewDataSource,UITableViewDelegate>{
    int curPage;
    int totalCount;//商品总数量
    NSMutableArray *_dataArray;
    UITableView *_mTableView;
    BOOL isFir;
}
@end

@implementation NakedDriOrderListView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        curPage = 1;
        _dataArray = [NSMutableArray array];
        _mTableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                  style:UITableViewStyleGrouped];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:_mTableView];
        [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0);
            make.top.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.bottom.equalTo(self).offset(0);
        }];
        if (@available(iOS 11.0, *)) {
            _mTableView.estimatedRowHeight = 0;
            _mTableView.estimatedSectionHeaderHeight = 0;
            _mTableView.estimatedSectionFooterHeight = 0;
        }
        [self setupHeaderRefresh];
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict{
    if (dict) {
        _dict = dict;
        if (isFir) {
            return;
        }
        [_mTableView.header beginRefreshing];
    }
}

#pragma mark -- 网络请求
- (void)setupHeaderRefresh{
    // 刷新功能
    MJRefreshStateHeader*header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self headerRereshing];
    }];
    [header setTitle:@"用力往下拉我!!!" forState:MJRefreshStateIdle];
    [header setTitle:@"快放开我!!!" forState:MJRefreshStatePulling];
    [header setTitle:@"努力刷新中..." forState:MJRefreshStateRefreshing];
    _mTableView.header = header;
    [_mTableView.header beginRefreshing];
}

- (void)setupFootRefresh{
    MJRefreshAutoNormalFooter*footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
    [footer setTitle:@"加载更多订单" forState:MJRefreshStateIdle];
    [footer setTitle:@"好了，可以放松一下手指" forState:MJRefreshStatePulling];
    [footer setTitle:@"努力加载中，请稍候" forState:MJRefreshStateRefreshing];
    _mTableView.footer = footer;
}
#pragma mark - refresh
- (void)headerRereshing{
    [self loadNewRequestWith:YES];
}

- (void)footerRereshing{
    [self loadNewRequestWith:NO];
}

- (void)loadNewRequestWith:(BOOL)isPullRefresh{
    if (isPullRefresh){
        curPage = 1;
        [_dataArray removeAllObjects];
    }
    [self getCommodityData];
}
#pragma mark - 网络数据
- (void)getCommodityData{
    if ([self.dict[@"netUrl"]length]==0) {
        [_mTableView.header endRefreshing];
        return;
    }
    isFir = YES;
    [SVProgressHUD show];
    self.userInteractionEnabled = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"cpage"] = @(curPage);
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,self.dict[@"netUrl"]];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        [_mTableView.header endRefreshing];
        [_mTableView.footer endRefreshing];
        if ([response.error intValue]==0) {
            [self setupFootRefresh];
            if ([YQObjectBool boolForObject:response.data]){
                    [self setListData:response.data[@"list"] and:response.data[@"list_count"]];
                }
            [_mTableView reloadData];
            self.userInteractionEnabled = YES;
        }
    } requestURL:url params:params];
}

//更新list数据
- (void)setListData:(NSDictionary *)dicList and:(id)couDic{
    if([YQObjectBool boolForObject:dicList]){
        _mTableView.footer.state = MJRefreshStateIdle;
        curPage++;
        totalCount = [couDic intValue];
        NSArray *seaArr = [NakedDriOListInfo objectArrayWithKeyValuesArray:dicList];
        [_dataArray addObjectsFromArray:seaArr];
        if(_dataArray.count>=totalCount){
            //已加载全部数据
            MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_mTableView.footer;
            [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
            _mTableView.footer.state = MJRefreshStateNoMoreData;
        }
    }else{
        MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_mTableView.footer;
        [footer setTitle:@"暂时没有商品" forState:MJRefreshStateNoMoreData];
        _mTableView.footer.state = MJRefreshStateNoMoreData;
    }
}
#pragma mark -- UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NakedDriAllListCell *cell = [NakedDriAllListCell cellWithTableView:tableView];
    cell.back = ^(BOOL isPay){
        if (isPay) {
            [self gotoPayViewController:indexPath.section];
        }else{
            [self cancelOrder:indexPath.section];
        }
    };
    NakedDriOListInfo *info;
    cell.staue = _dict[@"title"];
    if (indexPath.section<_dataArray.count) {
        info = _dataArray[indexPath.section];
    }
    cell.info = info;
    return cell;
}

- (void)gotoPayViewController:(NSInteger)index{
    NakedDriOListInfo *info;
    if (index<_dataArray.count) {
        info = _dataArray[index];
    }
    PayViewController *payVc = [PayViewController new];
    payVc.isStone = YES;
    payVc.orderId = info.id;
    [self.superNav pushViewController:payVc animated:YES];
}

- (void)cancelOrder:(NSInteger)index{
    NakedDriOListInfo *info;
    if (index<_dataArray.count) {
        info = _dataArray[index];
    }
    NSString *url = [NSString stringWithFormat:@"%@stoneCancelOrderDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = info.id;
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [_dataArray removeObjectAtIndex:index];
            [_mTableView reloadData];
        }
    } requestURL:url params:params];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NakedDriOListInfo *info;
    if (indexPath.section<_dataArray.count) {
        info = _dataArray[indexPath.section];
    }
    NakedDriDetailOrderVc *orderVc = [NakedDriDetailOrderVc new];
    orderVc.orderId = info.id;
    [self.superNav pushViewController:orderVc animated:YES];
}

@end
