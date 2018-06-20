//
//  UserOrderListVC.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/23.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "UserOrderListVC.h"
#import "AAChartKit.h"
#import "StrWithIntTool.h"
#import "SearchResultsVC.h"
#import "MyOrderListCell.h"
#import "CDRTranslucentSideBar.h"
#import "MyOrderRightView.h"
#import "UserOrderImgInfo.h"
#import "UserCustomerInfo.h"
@interface UserOrderListVC ()<CDRTranslucentSideBarDelegate,UITableViewDataSource,
    UITableViewDelegate,AAChartViewDidFinishLoadDelegate>
@property (nonatomic,strong) AAChartModel *aaChartModel;
@property (nonatomic,strong) AAChartView  *aaChartView;
@property (nonatomic,strong) CDRTranslucentSideBar *rightSideBar;
@property (nonatomic,  weak) MyOrderRightView *slideRightTab;
@property (nonatomic,  weak) UIView *baView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,  copy) NSArray *myMinData;
@property (nonatomic,  copy) NSArray *allMinData;
@property (nonatomic,  copy) NSArray *myData;
@property (nonatomic,  copy) NSArray *allData;
@property (nonatomic,  copy) NSDictionary *mutDic;
@property (nonatomic,assign) int curPage;
@end

@implementation UserOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.dataArray = [NSMutableArray new];
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *date = [formatter stringFromDate:yesterday];
    self.mutDic = @{@"sdate":date,@"edate":date,@"sscopeid":@"1"};
    [self creatNaviBtn];
    [self setupTableView];
    [self setupRightSiderBar];
    [self getTableHeadData];
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
#pragma mark - 网络数据
- (void)getTableHeadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"date"] = [UserOrderImgInfo getImgData];
    NSString *url = [NSString stringWithFormat:@"%@OrderDateScaleCount",baseUrl];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data]){
                NSArray *arr = [UserOrderImgInfo mj_objectArrayWithKeyValuesArray:response.data[@"dateTableCount"]];
                NSMutableArray *mutA = @[].mutableCopy;
                NSMutableArray *mutB = @[].mutableCopy;
                for (UserOrderImgInfo *info in arr) {
                    [mutA addObject:info.mycount];
                    [mutB addObject:info.count];
                }
                self.myData = mutA.copy;
                self.allData = mutB.copy;
                [self setupTableHeadView];
            }
            [SVProgressHUD dismiss];
        }
    } requestURL:url params:params];
}
#pragma mark -- creatTable
- (void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = DefaultColor;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (void)setupTableHeadView{
    AAChartType type = AAChartTypeBar;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 400)];
    headView.backgroundColor = DefaultColor;
    [self setUpTheAAChartViewWithChartType:type andView:headView];
    self.tableView.tableHeaderView = headView;
}
#pragma mark --绘制图形--
- (void)setUpTheAAChartViewWithChartType:(AAChartType)chartType andView:(UIView *)view{
    self.aaChartView = [[AAChartView alloc]init];
    self.aaChartView.delegate = self;
    self.aaChartView.scrollEnabled = NO;//禁用 AAChartView 滚动效果
    [view addSubview:self.aaChartView];
    [self.aaChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(0);
        make.left.equalTo(view).offset(0);
        make.right.equalTo(view).offset(0);
        make.bottom.equalTo(view).offset(0);
    }];
    //设置 AAChartView 的背景色是否为透明
    self.aaChartView.isClearBackgroundColor = YES;
    
    self.aaChartModel = AAObject(AAChartModel)
    .chartTypeSet(chartType) //图表类型
    .titleSet(@"") //图表主标题 近半年下单数据汇总
    .subtitleSet(@"") //图表副标题
    .yAxisTitleSet(@"")//设置Y轴标题
    .yAxisLineWidthSet(@1) //Y轴轴线线宽为0即是隐藏Y轴轴线
    .colorsThemeSet(@[@"#0070C0",@"#86A44A",@"#F79646",@"#C00000"])//设置主体颜色数组
    .yAxisLabelsEnabledSet(false)
    .borderRadiusSet(@1)
    .dataLabelFontSizeSet(@6)
    .dataLabelEnabledSet(true) //是否显示数据
//    .yAxisTickPositionsSet(@[@0, @25, @50, @75, @100, @125, @200])//指定y轴坐标
    .tooltipValueSuffixSet(@"件")//设置浮动提示框单位后缀
    .backgroundColorSet(@"#4b2b7f")
    .yAxisGridLineWidthSet(@1)//y轴横向分割线宽度为0(即是隐藏分割线)
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet(@"本人APP下单")
                 .dataSet(self.myData),
                 AAObject(AASeriesElement)
                 .nameSet(@"个人总下单")
                 .dataSet(@[@120,@400,@390,@500,@60,@300]),
                 AAObject(AASeriesElement)
                 .nameSet(@"总APP下单")
                 .dataSet(@[@240,@600,@500,@900,@100,@500]),
                 AAObject(AASeriesElement)
                 .nameSet(@"总下单")
                 .dataSet(self.allData)
                 ]
               );
    [self configureTheStyleForDifferentTypeChart];//为不同类型图表设置样式
    [self.aaChartView aa_drawChartWithChartModel:_aaChartModel];
}

- (void)configureTheStyleForDifferentTypeChart {
    _aaChartModel.categories = [UserOrderImgInfo getImgMonthData];//设置X轴坐标文字内容
    _aaChartModel.animationType = AAChartAnimationBounce;//图形的渲染动画为弹性动画
    _aaChartModel.animationDuration = @1200;//图形渲染动画时长为1200毫秒
//         _aaChartModel.xAxisTickInterval = @2;
    /*设置 X轴坐标点的间隔数,默认是1(手机端的屏幕较为狭窄, 如果X轴坐标点过多,
     文字过于密集的时候可以设置此属性值, 用户的密集恐惧症将得到有效治疗😝)*/
}
#pragma mark -- AAChartView delegate
- (void)AAChartViewDidFinishLoad {
    NSLog(@"🔥🔥🔥🔥🔥 AAChartView content did finish load!!!");
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
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupFootRefresh{
    MJRefreshAutoNormalFooter*footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
    [footer setTitle:@"加载更多订单" forState:MJRefreshStateIdle];
    [footer setTitle:@"好了，可以放松一下手指" forState:MJRefreshStatePulling];
    [footer setTitle:@"努力加载中，请稍候" forState:MJRefreshStateRefreshing];
    self.tableView.mj_footer = footer;
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
//    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"cpage"] = @(self.curPage);
    params[@"pageNum"] = @(24);
    [params addEntriesFromDictionary:self.mutDic];
    NSString *url = [NSString stringWithFormat:@"%@ModelOrderSearchGroupByCustomer",baseUrl];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([response.error intValue]==0) {
            [self setupFootRefresh];
            NSDictionary *cusData = response.data[@"customerOrderlist"];
            if ([YQObjectBool boolForObject:cusData]){
                [self setListData:cusData[@"orderList"]and:cusData[@"list_count"]];
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
        self.tableView.mj_footer.state = MJRefreshStateIdle;
        self.curPage++;
        int totalCount = [couDic intValue];
        NSArray *seaArr = [UserCustomerInfo mj_objectArrayWithKeyValuesArray:dicList];
        [_dataArray addObjectsFromArray:seaArr];
        if(_dataArray.count>=totalCount){
            //已加载全部数据
            MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)self.tableView.mj_footer;
            [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }else{
        //[self.tableView.mj_header removeFromSuperview];
        NSString *str = [NSString stringWithFormat:@"%@ 没有下单",self.mutDic[@"sdate"]];
        MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)self.tableView.mj_footer;
        [footer setTitle:str forState:MJRefreshStateNoMoreData];
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 40.0f;
    }
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 40)];
        UILabel *lab = [[UILabel alloc]init];
        [headV addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headV).offset(0);
            make.left.equalTo(headV).offset(15);
            make.right.equalTo(headV).offset(-15);
            make.bottom.equalTo(headV).offset(0);
        }];
        lab.textColor = MAIN_COLOR;
        lab.font = [UIFont systemFontOfSize:14];
        lab.numberOfLines = 2;
        lab.text = @"2018-01~2018-06共有28个客户下单，订单数20单，下单量40件";
        return headV;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderListCell *listCell = [MyOrderListCell cellWithTableView:tableView];
    UserCustomerInfo *info;
    if (self.dataArray.count>indexPath.section) {
        info = self.dataArray[indexPath.section];
    }
    listCell.info = info;
    return listCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserCustomerInfo *info;
    if (self.dataArray.count>indexPath.section) {
        info = self.dataArray[indexPath.section];
    }
    NSMutableDictionary *mutD  = self.mutDic.mutableCopy;
    mutD[@"customerID"] = info.customerID;
    SearchResultsVC *resVc = [SearchResultsVC new];
    resVc.mutDic = mutD.copy;
    [self.navigationController pushViewController:resVc animated:YES];
}

@end
