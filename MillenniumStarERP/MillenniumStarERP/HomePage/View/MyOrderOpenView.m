//
//  MyOrderOpenView.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/6/19.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "MyOrderOpenView.h"
#import "CustomTitleView.h"
#import "CustomTextField.h"
#import "StrWithIntTool.h"
@interface MyOrderOpenView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    int curPage;
    int totalCount;
}
@property(strong, nonatomic)UITableView *searchTab;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)CustomTextField *searchFie;
@end
@implementation MyOrderOpenView

- (id)init{
    self = [super init];
    if (self) {
        [self setupSearchBar];
        [self createBaseView];
    }
    return self;
}

#pragma mark -- 创建导航按钮-头视图
- (void)setupSearchBar{
    CustomTitleView *titleView = [[CustomTitleView alloc]init];
    titleView.backgroundColor = [UIColor clearColor];
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.height.mas_equalTo(@30);
    }];
    
    UIButton *seaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [seaBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [seaBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [titleView addSubview:seaBtn];
    [seaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView).offset(0);
        make.width.mas_equalTo(@30);
        make.right.equalTo(titleView).offset(0);
        make.bottom.equalTo(titleView).offset(0);
    }];
    
    CustomTextField *titleFie = [[CustomTextField alloc]init];
    titleFie.text = _searchMes;
    titleFie.delegate = self;
    [titleView addSubview:titleFie];
    [titleFie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView).offset(0);
        make.left.equalTo(titleView).offset(0);
        make.right.equalTo(titleView).offset(-40);
        make.bottom.equalTo(titleView).offset(0);
    }];
    _searchFie = titleFie;
}

- (void)createBaseView{
    UITableView *table = [[UITableView alloc]init];
    table.delegate = self;
    table.dataSource = self;
    [self addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    self.searchTab = table;
    self.searchTab.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
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
    _searchTab.header = header;
    [self.searchTab.header beginRefreshing];
}

- (void)setupFootRefresh{
    MJRefreshAutoNormalFooter*footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
    [footer setTitle:@"上拉有惊喜" forState:MJRefreshStateIdle];
    [footer setTitle:@"好了，可以放松一下手指" forState:MJRefreshStatePulling];
    [footer setTitle:@"努力加载中，请稍候" forState:MJRefreshStateRefreshing];
    _searchTab.footer = footer;
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
        [self.dataArray removeAllObjects];
    }
    [self getCommodityData];
}

- (void)searchClick{
    [_searchFie resignFirstResponder];
    NSMutableArray *addArr = @[].mutableCopy;
    if (_searchFie.text.length>0) {
        NSArray *arr = [_searchFie.text componentsSeparatedByString:@" "];
        for (NSString *str in arr) {
            if (![str isEqualToString:@""]) {
                [addArr addObject:str];
            }
        }
        self.searchMes = [StrWithIntTool strWithArr:addArr];
    }else{
        self.searchMes = @"";
    }
    [self setupHeaderRefresh];
}

- (void)getCommodityData{
    [SVProgressHUD show];
    self.userInteractionEnabled = NO;
    NSString *url = [NSString stringWithFormat:@"%@GetCustomerList",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"keyword"] = self.searchMes;
    params[@"cpage"] = @(curPage);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        [self.searchTab.header endRefreshing];
        [self.searchTab.footer endRefreshing];
        if ([response.error intValue]==0) {
            [self setupFootRefresh];
            if ([YQObjectBool boolForObject:response.data]){
                [self setupListDataWithDict:response.data];
            }
            [self.searchTab reloadData];
            [SVProgressHUD dismiss];
            self.userInteractionEnabled = YES;
        }
    } requestURL:url params:params];
}

- (void)setupListDataWithDict:(NSDictionary *)dict{
    if([dict[@"list"] isKindOfClass:[NSArray class]]
       && [dict[@"list"] count]>0){
        self.searchTab.footer.state = MJRefreshStateIdle;
        curPage++;
        totalCount = [dict[@"list_count"]intValue];
        NSArray *seaArr = [CustomerInfo objectArrayWithKeyValuesArray:dict[@"list"]];
        [_dataArray addObjectsFromArray:seaArr];
        if(_dataArray.count>=totalCount){
            //已加载全部数据
            MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_searchTab.footer;
            [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
            self.searchTab.footer.state = MJRefreshStateNoMoreData;
        }
    }else{
        //[self.tableView.header removeFromSuperview];
        MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_searchTab.footer;
        [footer setTitle:@"暂时没有商品" forState:MJRefreshStateNoMoreData];
        _searchTab.footer.state = MJRefreshStateNoMoreData;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *seaCell = [tableView dequeueReusableCellWithIdentifier:@"seaCell"];
    if (!seaCell) {
        seaCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seaCell"];
    }
    CustomerInfo *cus;
    if (indexPath.row<self.dataArray.count) {
        cus = self.dataArray[indexPath.row];
    }
    seaCell.textLabel.text = cus.customerName;
    return seaCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomerInfo *cus;
    if (indexPath.row<self.dataArray.count) {
        cus = self.dataArray[indexPath.row];
    }
}

@end
