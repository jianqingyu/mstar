//
//  UserOrderListVC.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/23.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "UserOrderListVC.h"
#import "SearchResultDetailVC.h"
#import "SearchResultTableCell.h"
#import "SearchResultInfo.h"
#import "CDRTranslucentSideBar.h"
#import "MyOrderRightView.h"
@interface UserOrderListVC ()<CDRTranslucentSideBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) CDRTranslucentSideBar *rightSideBar;
@property (nonatomic,  weak) MyOrderRightView *slideRightTab;
@property (nonatomic,  weak) UIView *baView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,  copy) NSDictionary *mutDic;
@property (nonatomic,assign) int curPage;
@end

@implementation UserOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.dataArray = [NSMutableArray new];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *date = [formatter stringFromDate:[NSDate date]];
    self.mutDic = @{@"sdate":date,@"edate":date,@"sscopeid":@"2"};
    [self creatNaviBtn];
    [self setupTableView];
    [self setupRightSiderBar];
    [self setupHeaderRefresh];
    [self createBackView];
}

- (void)creatNaviBtn{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选"
         style:UIBarButtonItemStyleDone target:self action:@selector(searchList)];
}

- (void)searchList{
    [self.rightSideBar show];
}
#pragma mark -- creatTable
- (void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = DefaultColor;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 110;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
    }];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)createBackView{
    UIView *bView = [UIView new];
    bView.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
    bView.hidden = YES;
    [self.view addSubview:bView];
    [bView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.baView = bView;
}
#pragma mark -- 创建侧滑菜单
- (void)setupRightSiderBar{
    CGFloat width = MIN(SDevWidth, SDevHeight);
    CGFloat height = MAX(SDevWidth, SDevHeight);
    self.rightSideBar = [[CDRTranslucentSideBar alloc] initWithDirection:YES];
    self.rightSideBar.delegate = self;
    self.rightSideBar.sideBarWidth = width*0.8;
    CGRect frame = CGRectMake(0, 0, width*0.8, height);
    MyOrderRightView *slideTab = [[MyOrderRightView alloc]initWithFrame:frame];
    slideTab.back = ^(id model,BOOL isData) {
        if (isData) {
            self.mutDic = model;
            [self.tableView.mj_header beginRefreshing];
        }else{
            BaseViewController *vc = model[@"push"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    [self.rightSideBar setContentViewInSideBar:slideTab];
    slideTab.rightSideBar = self.rightSideBar;
    self.slideRightTab = slideTab;
}
#pragma mark - Gesture Handler 侧滑出菜单
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.rightSideBar.isCurrentPanGestureTarget = YES;
    }
    [self.rightSideBar handlePanGestureToShow:recognizer inView:self.view];
}

#pragma mark - CDRTranslucentSideBarDelegate
- (void)sideBar:(CDRTranslucentSideBar *)sideBar willAppear:(BOOL)animated
{
    self.baView.hidden = NO;
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar willDisappear:(BOOL)animated
{
    self.baView.hidden = YES;
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
    self.tableView.header = header;
    [self.tableView.header beginRefreshing];
}

- (void)setupFootRefresh{
    MJRefreshAutoNormalFooter*footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
    [footer setTitle:@"加载更多订单" forState:MJRefreshStateIdle];
    [footer setTitle:@"好了，可以放松一下手指" forState:MJRefreshStatePulling];
    [footer setTitle:@"努力加载中，请稍候" forState:MJRefreshStateRefreshing];
    self.tableView.footer = footer;
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
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if ([response.error intValue]==0) {
            [self setupFootRefresh];
            if ([YQObjectBool boolForObject:response.data]){
                [self setListData:response.data[@"orderList"]and:response.data[@"list_count"]];
                [self.tableView reloadData];
                self.view.userInteractionEnabled = YES;
            }
            [SVProgressHUD dismiss];
        }
    } requestURL:url params:params];
}

//更新list数据
- (void)setListData:(NSDictionary *)dicList and:(id)couDic{
    if([YQObjectBool boolForObject:dicList]){
        self.tableView.footer.state = MJRefreshStateIdle;
        self.curPage++;
        int totalCount = [couDic intValue];
        NSArray *seaArr = [SearchResultInfo objectArrayWithKeyValuesArray:dicList];
        [_dataArray addObjectsFromArray:seaArr];
        if(_dataArray.count>=totalCount){
            //已加载全部数据
            MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)self.tableView.footer;
            [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        }
    }else{
        //[self.tableView.header removeFromSuperview];
        MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)self.tableView.footer;
        [footer setTitle:@"暂时没有商品" forState:MJRefreshStateNoMoreData];
        self.tableView.footer.state = MJRefreshStateNoMoreData;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultTableCell *resCell = [SearchResultTableCell cellWithTableView:tableView];
    SearchResultInfo *info;
    if (self.dataArray.count>indexPath.row) {
        info = self.dataArray[indexPath.row];
    }
    resCell.info = info;
    return resCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultInfo *info;
    if (self.dataArray.count>indexPath.row) {
        info = self.dataArray[indexPath.row];
    }
    SearchResultDetailVC *detailVc = [SearchResultDetailVC new];
    detailVc.orderNum = info.orderNum;
    [self.navigationController pushViewController:detailVc animated:YES];
}

@end
