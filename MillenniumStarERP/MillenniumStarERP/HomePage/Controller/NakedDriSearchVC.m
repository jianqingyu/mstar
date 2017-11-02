//
//  NakedDriSearchVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriSearchVC.h"
#import "NakedDriPriceVC.h"
#import "StrWithIntTool.h"
#import "NakedDriSeaHeadV.h"
#import "ProductListVC.h"
#import "NakedDriSeaListInfo.h"
#import "NakedDriSeaTableCell.h"
#import "NakedDriConfirmOrderVc.h"
@interface NakedDriSearchVC ()<UITableViewDelegate,UITableViewDataSource>{
    int curPage;
    int pageCount;
    int totalCount;//商品总数量
}
@property (nonatomic,assign) BOOL isFir;
@property (nonatomic,assign) BOOL isShow;
@property (nonatomic,assign) int idxPage;
@property (nonatomic,  weak) UILabel *numLab;
@property (nonatomic,  copy) NSString *sortStr;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (weak,  nonatomic) IBOutlet UIView *bottomV;
@property (weak,  nonatomic) IBOutlet UIButton *sureBtn;
@property (weak,  nonatomic) IBOutlet UILabel *headLab;
@property (weak,  nonatomic) IBOutlet UIScrollView *backScr;
@property (weak,  nonatomic) IBOutlet UIView *bottomView;
@property (weak,  nonatomic) IBOutlet UIButton *chooseBtn;
@property (strong,nonatomic) IBOutletCollection(UIButton) NSArray *bottomBtns;
@end

@implementation NakedDriSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索结果";
    self.isShow = ![[AccountTool account].isNoDriShow intValue];
    self.dataArray = @[].mutableCopy;
    [self setupBaseTableView];
    [self setupHeaderRefresh];
    [self setRightNaviBar];
    //其他页面选裸钻
    if (self.isCus||self.isSel) {
        self.bottomV.hidden = YES;
        self.chooseBtn.hidden = YES;
        self.sureBtn.hidden = NO;
    }
    if ([[AccountTool account].isNorm intValue]==1) {
        self.chooseBtn.hidden = YES;
    }
    if (!self.isShow) {
        for (UIButton *btn in self.bottomBtns) {
            btn.enabled = NO;
        }
    }
}

- (void)setIsRef:(BOOL)isRef{
    if (isRef) {
        _isRef = isRef;
        [self.tableView.header beginRefreshing];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setRightNaviBar{
    UIButton *bar = [UIButton buttonWithType:UIButtonTypeCustom];
    bar.frame = CGRectMake(0, 0, 80, 28);
    [bar setTitle:@"横竖屏切换" forState:UIControlStateNormal];
    bar.titleLabel.font = [UIFont systemFontOfSize:12];
    [bar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bar addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bar];
}

- (void)btnClick:(id)sender{
    if (SDevWidth<SDevHeight) {
        [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }
}
//屏幕横竖屏切换
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)setupBaseTableView{
    for (UIButton *btn in _bottomBtns) {
        btn.enabled = ![[AccountTool account].isNoShow intValue];
        [btn setLayerWithW:3 andColor:BordColor andBackW:0.001];
    }
    [self.chooseBtn setLayerWithW:3 andColor:BordColor andBackW:0.001];
    [self.sureBtn setLayerWithW:3 andColor:BordColor andBackW:0.001];
    self.backScr.bounces = NO;
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.backScr addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backScr).offset(30);
        make.left.equalTo(self.backScr).offset(0);
        make.right.equalTo(self.backScr).offset(0);
        make.bottom.equalTo(self.backScr).offset(0);
        make.centerY.mas_equalTo(self.backScr.mas_centerY);
        make.width.mas_equalTo(SDevWidth);
    }];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.backScr.contentSize = CGSizeMake(SDevWidth, 0);
    
    UILabel *lab = [UILabel new];
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:14];
    lab.textAlignment = NSTextAlignmentCenter;
    [lab setLayerWithW:10 andColor:BordColor andBackW:0.0001];
    lab.hidden = YES;
    lab.backgroundColor = CUSTOM_COLOR_ALPHA(80, 80, 80, 0.5);
    [self.view addSubview:lab];
    [self.view bringSubviewToFront:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 24));
        make.bottom.equalTo(self.view).offset(-60);
    }];
    self.numLab = lab;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (totalCount==0) {
        return;
    }
    // 得到每页高度
    CGFloat pageWidth = sender.frame.size.height;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = (floor((sender.contentOffset.y - pageWidth / 2) / pageWidth) + 1)+1;
//    NSLog(@"%d",currentPage);
    int toPage = totalCount%30==0?totalCount/30:totalCount/30+1;
    if (self.idxPage!=currentPage&&totalCount!=0) {
        self.idxPage = currentPage;
        int num = self.idxPage/2+1;
        if (num>toPage) {
            num = toPage;
        }
        self.numLab.text = [NSString stringWithFormat:@"%d/%d",num,toPage];
        if(self.numLab.hidden){
            self.numLab.hidden = NO;
        }
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
    _tableView.header = header;
    [self.tableView.header beginRefreshing];
}

- (void)setupFootRefresh{
    
    MJRefreshAutoNormalFooter*footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
    [footer setTitle:@"上拉有惊喜" forState:MJRefreshStateIdle];
    [footer setTitle:@"好了，可以放松一下手指" forState:MJRefreshStatePulling];
    [footer setTitle:@"努力加载中，请稍候" forState:MJRefreshStateRefreshing];
    self.tableView.footer = footer;
}
#pragma mark - MJRefresh
- (void)headerRereshing{
    [self loadNewRequestWith:YES];
}

- (void)footerRereshing{
    [self loadNewRequestWith:NO];
}

- (void)loadNewRequestWith:(BOOL)isPullRefresh{
    if (isPullRefresh){
        curPage = 1;
        self.numLab.hidden = YES;
        [self.dataArray removeAllObjects];
    }
    NSMutableDictionary *params = [self dictForLoadData];
    [self getCommodityData:params];
}

- (NSMutableDictionary *)dictForLoadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"cpage"] = @(curPage);
    params[@"orderby"] = _sortStr;
    if (self.seaDic.count>0) {
        [params addEntriesFromDictionary:self.seaDic];
    }
    return params;
}
#pragma mark - 信息查找
//通过搜索关键词查找信息
- (void)getCommodityData:(NSMutableDictionary *)params{
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    NSString *url = [NSString stringWithFormat:@"%@stoneList",baseUrl];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if ([response.error intValue]==0) {
            [self setupFootRefresh];
            if ([YQObjectBool boolForObject:response.data]){
                [self setupDataWithData:response.data];
                [self setupListDataWithDict:response.data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
            self.view.userInteractionEnabled = YES;
        }
    } requestURL:url params:params];
}
//初始化数据
- (void)setupDataWithData:(NSDictionary *)data{
    if (self.isFir) {
        return;
    }
    if([YQObjectBool boolForObject:data[@"stone"][@"searchKey"]]){
        self.headLab.text = data[@"stone"][@"searchKey"];
    }
    if([YQObjectBool boolForObject:data[@"stone"][@"headline"]]){
        NSArray *topArr = data[@"stone"][@"headline"];
        if (!self.isShow) {
            NSMutableArray *mutA = topArr.mutableCopy;
            [mutA removeObjectAtIndex:2];
            topArr = mutA.copy;
        }
        [self setTableViewHeadView:topArr];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(((topArr.count+1)*80+40));
        }];
        self.backScr.contentSize = CGSizeMake(((topArr.count+1)*80+40), 0);
    }
    self.isFir = YES;
}

- (void)setTableViewHeadView:(NSArray *)arr{
    CGRect frame = CGRectMake(0, 0, (arr.count+1)*80+40, 30);
    NakedDriSeaHeadV *head = [[NakedDriSeaHeadV alloc]initWithFrame:frame];
    head.back = ^(NSString *mess){
        _sortStr = mess;
        [self.tableView.header beginRefreshing];
    };
    head.topArr = arr;
    [self.backScr addSubview:head];
    [head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backScr).offset(0);
        make.left.equalTo(self.backScr).offset(0);
        make.right.equalTo(self.backScr).offset(0);
        make.height.mas_equalTo(30);
    }];
}

//初始化列表数据
- (void)setupListDataWithDict:(NSDictionary *)data{
    if([YQObjectBool boolForObject:data[@"stone"][@"list"]]){
        self.tableView.footer.state = MJRefreshStateIdle;
        curPage++;
        totalCount = [data[@"stone"][@"list_count"]intValue];
        NSArray *seaArr = [NakedDriSeaListInfo objectArrayWithKeyValuesArray:data[@"stone"][@"list"]];
        [_dataArray addObjectsFromArray:seaArr];
        if(_dataArray.count>=totalCount){
            MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)self.tableView.footer;
            [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        }
    }else{
        MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)self.tableView.footer;
        [footer setTitle:@"暂时没有商品" forState:MJRefreshStateNoMoreData];
        self.tableView.footer.state = MJRefreshStateNoMoreData;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NakedDriSeaTableCell *cell = [NakedDriSeaTableCell cellWithTableView:tableView];
    cell.isCus = self.isCus;
    cell.isShow = self.isShow;
    cell.back = ^(BOOL isSel){
        if (isSel) {
            [self cellBackWithIndex:indexPath.row];
        }
        [self.tableView reloadData];
    };
    NakedDriSeaListInfo *listInfo;
    if (indexPath.row<self.dataArray.count) {
        listInfo = self.dataArray[indexPath.row];
    }
    cell.seaInfo = listInfo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.isPro) {
//        for (int i=0; i<_dataArray.count; i++) {
//            NakedDriSeaListInfo *dInfo = _dataArray[i];
//            if (i!=indexPath.row) {
//                dInfo.isSel = NO;
//            }
//        }
//    }
    NakedDriSeaListInfo *listInfo;
    if (indexPath.row<_dataArray.count) {
        listInfo = _dataArray[indexPath.row];
    }
    listInfo.isSel = !listInfo.isSel;
    [self.tableView reloadData];
}

- (void)cellBackWithIndex:(NSInteger)index{
    NakedDriSeaListInfo *listInfo;
    if (index<self.dataArray.count) {
        listInfo = self.dataArray[index];
    }
    NakedDriPriceVC *nakedVc = [NakedDriPriceVC new];
    nakedVc.orderId = listInfo.id;
    [self.navigationController pushViewController:nakedVc animated:YES];
}

- (IBAction)resetClik:(id)sender {
    for (NakedDriSeaListInfo *listInfo in self.dataArray) {
        listInfo.isSel = NO;
    }
    [self.tableView reloadData];
}

- (IBAction)sureClick:(id)sender {
    [self chooseCustomDri];
}
//选择裸钻
- (void)chooseCustomDri{
    NSArray *arr = [self arrWithInfo];
    if (arr.count==0) {
        [MBProgressHUD showError:@"请选择钻石"];
        return;
    }
    if (arr.count>1) {
        [MBProgressHUD showError:@"只能选择一个钻石"];
        return;
    }
    NakedDriSeaListInfo *listInfo = arr[0];
    if (listInfo.CertCode.length==0) {
        [MBProgressHUD showError:@"没有证书不能选择"];
        return;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationDriName
                                object:nil userInfo:@{UserInfoDriName:listInfo}];
    if (self.isCus) {//定制
        return;
    }
    NSInteger count = self.navigationController.viewControllers.count;
    BaseViewController *baseVc = self.navigationController.viewControllers[count-3];
    [self.navigationController popToViewController:baseVc animated:YES];
}

- (IBAction)chooseProClick:(id)sender {
    [self chooseCustomPro];
}
//选择戒托
- (void)chooseCustomPro{
    NSArray *arr = [self arrWithInfo];
    if (arr.count==0) {
        [MBProgressHUD showError:@"请选择钻石"];
        return;
    }
    if (arr.count>1) {
        [MBProgressHUD showError:@"只能选择一个钻石"];
        return;
    }
    NakedDriSeaListInfo *listInfo = arr[0];
    if (listInfo.CertCode.length==0) {
        [MBProgressHUD showError:@"没有证书不能选择"];
        return;
    }
    ProductListVC *listVc = [ProductListVC new];
    listVc.driInfo = listInfo;
    NSDictionary *dic = listInfo.modelWeightRange;
    listVc.backDict = @{dic[@"key"]:dic[@"value"]}.mutableCopy;
    [self.navigationController pushViewController:listVc animated:YES];
}

- (IBAction)priceClick:(id)sender {
    NSArray *arr = [self arrWithIsSel];
    if (arr.count==0) {
        [MBProgressHUD showError:@"请选择钻石"];
        return;
    }
    NakedDriPriceVC *nakedVc = [NakedDriPriceVC new];
    if (self.seaDic[@"percent"]) {
        nakedVc.percent = self.seaDic[@"percent"];
    }
    nakedVc.orderId = [StrWithIntTool strWithArr:arr With:@","];
    [self.navigationController pushViewController:nakedVc animated:YES];
}

- (IBAction)orderCliCk:(id)sender {
    if (!self.isShow) {
        return;
    }
    NSArray *arr = [self arrWithIsSel];
    if (arr.count==0) {
        [MBProgressHUD showError:@"请选择钻石"];
        return;
    }
    NakedDriConfirmOrderVc *orderVc = [NakedDriConfirmOrderVc new];
    if (self.seaDic[@"percent"]) {
        orderVc.percent = self.seaDic[@"percent"];
    }
    orderVc.orderId = [StrWithIntTool strWithArr:arr With:@","];
    [self.navigationController pushViewController:orderVc animated:YES];
}

- (NSArray *)arrWithIsSel{
    NSMutableArray *mutA = [NSMutableArray new];
    for (NakedDriSeaListInfo *listInfo in self.dataArray) {
        if (listInfo.isSel) {
            [mutA addObject:listInfo.id];
        }
    }
    return mutA.copy;
}

- (NSArray *)arrWithInfo{
    NSMutableArray *mutA = [NSMutableArray new];
    for (NakedDriSeaListInfo *listInfo in self.dataArray) {
        if (listInfo.isSel) {
            [mutA addObject:listInfo];
        }
    }
    return mutA.copy;
}

@end
