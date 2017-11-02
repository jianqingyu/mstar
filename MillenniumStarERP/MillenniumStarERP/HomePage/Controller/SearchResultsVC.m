//
//  SearchResultsVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/15.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SearchResultsVC.h"
#import "SearchResultDetailVC.h"
#import "SearchResultTableCell.h"
#import "SearchResultInfo.h"
@interface SearchResultsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *resultTable;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)int curPage;
@end

@implementation SearchResultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索结果";
    self.dataArray = [NSMutableArray new];
    _resultTable.rowHeight = UITableViewAutomaticDimension;
    _resultTable.estimatedRowHeight = 90;
    [self setupHeaderRefresh];
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
    self.resultTable.header = header;
    [self.resultTable.header beginRefreshing];
}

- (void)setupFootRefresh{
    MJRefreshAutoNormalFooter*footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
    [footer setTitle:@"加载更多订单" forState:MJRefreshStateIdle];
    [footer setTitle:@"好了，可以放松一下手指" forState:MJRefreshStatePulling];
    [footer setTitle:@"努力加载中，请稍候" forState:MJRefreshStateRefreshing];
    self.resultTable.footer = footer;
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
        self.curPage = 1;
        [_dataArray removeAllObjects];
    }
    [self getCommodityData];
}
#pragma mark - 网络数据
- (void)getCommodityData{
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"cpage"] = @(self.curPage);
    [params addEntriesFromDictionary:self.mutDic];
    NSString *url = [NSString stringWithFormat:@"%@ModelOrderSearch",baseUrl];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        [self.resultTable.header endRefreshing];
        [self.resultTable.footer endRefreshing];
        if ([response.error intValue]==0) {
            [self setupFootRefresh];
            if ([YQObjectBool boolForObject:response.data]){
                [self setListData:response.data[@"orderList"]and:response.data[@"list_count"]];
                [self.resultTable reloadData];
                self.view.userInteractionEnabled = YES;
            }
            [SVProgressHUD dismiss];
        }
    } requestURL:url params:params];
}

//更新list数据
- (void)setListData:(NSDictionary *)dicList and:(id)couDic{
    if([YQObjectBool boolForObject:dicList]){
        self.resultTable.footer.state = MJRefreshStateIdle;
        self.curPage++;
        int totalCount = [couDic intValue];
        NSArray *seaArr = [SearchResultInfo objectArrayWithKeyValuesArray:dicList];
        [_dataArray addObjectsFromArray:seaArr];
        if(_dataArray.count>=totalCount){
            //已加载全部数据
            MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)self.resultTable.footer;
            [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
            self.resultTable.footer.state = MJRefreshStateNoMoreData;
        }
    }else{
        //[self.tableView.header removeFromSuperview];
        MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)self.resultTable.footer;
        [footer setTitle:@"暂时没有商品" forState:MJRefreshStateNoMoreData];
        self.resultTable.footer.state = MJRefreshStateNoMoreData;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultTableCell *resCell = [SearchResultTableCell cellWithTableView:tableView];
    SearchResultInfo *info;
    if (self.dataArray.count>indexPath.section) {
        info = self.dataArray[indexPath.section];
    }
    resCell.info = info;
    return resCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultInfo *info;
    if (self.dataArray.count>indexPath.section) {
        info = self.dataArray[indexPath.section];
    }
    SearchResultDetailVC *detailVc = [SearchResultDetailVC new];
    detailVc.orderNum = info.orderNum;
    [self.navigationController pushViewController:detailVc animated:YES];
}

@end
