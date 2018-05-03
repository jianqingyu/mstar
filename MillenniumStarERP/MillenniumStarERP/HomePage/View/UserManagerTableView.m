//
//  ServerTypeTableView.m
//  CheKu
//
//  Created by JIMU on 15/5/14.
//  Copyright (c) 2015年 puxiang. All rights reserved.
//

#import "UserManagerTableView.h"
#import "OrderListTableCell.h"
#import "OrderSettlementTableCell.h"
#import "OrderListNewInfo.h"
#import "ConfirmOrderVC.h"
#import "ProductionOrderVC.h"
#import "StausCount.h"
#import "SettlementListVC.h"
#import "ConfirmOrderCollectionVC.h"
@interface UserManagerTableView()<UITableViewDataSource,UITableViewDelegate>{
    int curPage;
    int totalCount;//商品总数量
    NSMutableArray *_dataArray;
    UITableView *_mTableView;
    BOOL isFir;
}

@end

@implementation UserManagerTableView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        curPage = 1;
        _dataArray = [NSMutableArray array];
        _mTableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                style:UITableViewStyleGrouped];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.rowHeight = UITableViewAutomaticDimension;
        _mTableView.estimatedRowHeight = 80;
        _mTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:_mTableView];
        [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.left.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.bottom.equalTo(self).offset(0);
        }];
        if (@available(iOS 11.0, *)) {
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
        [_mTableView.mj_header beginRefreshing];
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
    _mTableView.mj_header = header;
    [_mTableView.mj_header beginRefreshing];
}

- (void)setupFootRefresh{
    MJRefreshAutoNormalFooter*footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
    [footer setTitle:@"加载更多订单" forState:MJRefreshStateIdle];
    [footer setTitle:@"好了，可以放松一下手指" forState:MJRefreshStatePulling];
    [footer setTitle:@"努力加载中，请稍候" forState:MJRefreshStateRefreshing];
    _mTableView.mj_footer = footer;
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
        [_mTableView.mj_header endRefreshing];
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
        [_mTableView.mj_header endRefreshing];
        [_mTableView.mj_footer endRefreshing];
        if ([response.error intValue]==0) {
            [self setupFootRefresh];
            if ([YQObjectBool boolForObject:response.data]){
                switch ([self.dict[@"proId"]intValue]) {
                    case 10:case 20:
                        [self setListData:response.data[@"orderList"][@"list"]
                                      and:response.data[@"orderList"][@"list_count"]];
                        break;
                    case 30:
                        [self setListData:response.data[@"orderList"]
                                      and:response.data[@"list_count"]];
                        break;
                    case 40:
                        break;
                    default:
                        break;
                }
                if ([YQObjectBool boolForObject:response.data[@"statusCount"]]) {
                    StausCount *staC = [StausCount mj_objectWithKeyValues:response.data[@"statusCount"]];
                    NSArray *arr = @[@(staC.waitForValidate),@(staC.produceding),
                                     @(staC.waitForSend),@(staC.finished)];
                    [self listNotifacation:arr];
                }
                [_mTableView reloadData];
                self.userInteractionEnabled = YES;
            }
            [SVProgressHUD dismiss];
        }
    } requestURL:url params:params];
}

- (void)listNotifacation:(NSArray *)arr{
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationList
                                                       object:nil userInfo:@{ListNum:arr}];
}

//更新list数据
- (void)setListData:(NSDictionary *)dicList and:(id)couDic{
    if([YQObjectBool boolForObject:dicList]){
        _mTableView.mj_footer.state = MJRefreshStateIdle;
        curPage++;
        totalCount = [couDic intValue];
        NSArray *seaArr = [OrderListNewInfo mj_objectArrayWithKeyValuesArray:dicList];
        [_dataArray addObjectsFromArray:seaArr];
        if(_dataArray.count>=totalCount){
            //已加载全部数据
            MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_mTableView.mj_footer;
            [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
            _mTableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }else{
        //[self.tableView.header removeFromSuperview];
        MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_mTableView.mj_footer;
        [footer setTitle:@"暂时没有商品" forState:MJRefreshStateNoMoreData];
        _mTableView.mj_footer.state = MJRefreshStateNoMoreData;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    OrderListNewInfo *newInfo;
    if (indexPath.section<_dataArray.count) {
        newInfo = _dataArray[indexPath.section];
    }
    switch ([self.dict[@"proId"]intValue]) {
        case 10:case 20:
            cell = [self CellWithTab:tableView andIndex:indexPath andInfo:newInfo];
            break;
        case 30:
            cell = [self CellWithSTab:tableView andIndex:indexPath andInfo:newInfo];
            break;
        case 40:
            break;
        default:
            break;
    }
    return cell;
}
#pragma mark -- 不同的Cell
- (OrderListTableCell *)CellWithTab:(UITableView *)tableView
                           andIndex:(NSIndexPath *)indexPath andInfo:(OrderListNewInfo *)info{
    OrderListTableCell *cell = [OrderListTableCell cellWithTableView:tableView];
    cell.listInfo = info;
    return cell;
}

- (OrderSettlementTableCell *)CellWithSTab:(UITableView *)tableView
                                  andIndex:(NSIndexPath *)indexPath andInfo:(OrderListNewInfo *)info{
    OrderSettlementTableCell *cell = [OrderSettlementTableCell cellWithTableView:tableView];
    cell.listInfo = info;
    return cell;
}

#pragma mark -- UITableDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch ([self.dict[@"proId"]intValue]) {
        case 10:
            [self loadListVcWithIndex:indexPath];
            break;
        case 20:
            [self loadProduceVcWithIndex:indexPath];
            break;
        case 30:
            [self loadDeliveryWithIndex:indexPath];
            break;
        case 40:
            [self loadSettlementWithIndex:indexPath];
            break;
        default:
            break;
    }
}
#pragma mark -- 点击Cell进入列表
//待审核
- (void)loadListVcWithIndex:(NSIndexPath *)indexPath{
    ConfirmOrderCollectionVC *oDetailVc = [ConfirmOrderCollectionVC new];
    //    ConfirmOrderVC *orderVC = [ConfirmOrderVC new];
    oDetailVc.boolBack = ^(BOOL isDel){
        if (isDel) {
            if (_dataArray.count>indexPath.section) {
                [_dataArray removeObjectAtIndex:indexPath.section];
            }
        }else{
            [self updataIndexOrder:indexPath.section];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mTableView reloadData];
        });
    };
    OrderListNewInfo *newInfo;
    if (indexPath.section<_dataArray.count) {
        newInfo = _dataArray[indexPath.section];
    }
    oDetailVc.editId = newInfo.id;
    [self.superNav pushViewController:oDetailVc animated:YES];
}

- (void)updataIndexOrder:(NSInteger)section{
    OrderListNewInfo *newInfo;
    if (section<_dataArray.count) {
        newInfo = _dataArray[section];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"orderId"] = @(newInfo.id);
    NSString *url = [NSString stringWithFormat:@"%@ModelOrderWaitCheckItem",baseUrl];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0&&[YQObjectBool boolForObject:response.data]) {
            OrderListNewInfo *info = [OrderListNewInfo mj_objectWithKeyValues:response.data[@"orderInfo"]];
            _dataArray[section] = info;
        }
    } requestURL:url params:params];
}
//生产中
- (void)loadProduceVcWithIndex:(NSIndexPath *)indexPath{
    OrderListNewInfo *newInfo;
    if (indexPath.section<_dataArray.count) {
        newInfo = _dataArray[indexPath.section];
    }
    ProductionOrderVC *orderVc = [ProductionOrderVC new];
    orderVc.orderNum = newInfo.orderNum;
    [self.superNav pushViewController:orderVc animated:YES];
}
//已发货
- (void)loadDeliveryWithIndex:(NSIndexPath *)indexPath{
    OrderListNewInfo *newInfo;
    if (indexPath.section<_dataArray.count) {
        newInfo = _dataArray[indexPath.section];
    }
    SettlementListVC *listVc = [SettlementListVC new];
    listVc.orderNumber = newInfo.orderNum;
    [self.superNav pushViewController:listVc animated:YES];
}
//已完成
- (void)loadSettlementWithIndex:(NSIndexPath *)indexPath{
//    OrderListNewInfo *newInfo;
//    if (indexPath.section<_dataArray.count) {
//        newInfo = _dataArray[indexPath.section];
//    }
}

@end
