//
//  SearchCustomerVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/10/25.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "SearchCustomerVC.h"
#import "CustomerInfo.h"
#import "StrWithIntTool.h"
#import "CustomTextField.h"
@interface SearchCustomerVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    int curPage;
    int pageCount;
    int totalCount;//商品总数量
}
@property (nonatomic,  weak)UITextField *searchFie;
@property (weak,  nonatomic) IBOutlet UITableView *searchTab;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation SearchCustomerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSearchBar];
    self.dataArray = @[].mutableCopy;
    [self setupHeaderRefresh];
}

#pragma mark -- 创建导航按钮-头视图
- (void)setupSearchBar{
    CGFloat width = SDevWidth*0.8;
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    titleView.backgroundColor = [UIColor clearColor];
    CustomTextField *titleFie = [[CustomTextField alloc]initWithFrame:CGRectMake(0, 0, width-40, 30)];
    titleFie.text = _searchMes;
    titleFie.delegate = self;

    UIButton *seaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seaBtn.frame = CGRectMake(width-35, 0, 30, 30);
    [seaBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [seaBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [titleView addSubview:titleFie];
    [titleView addSubview:seaBtn];
    _searchFie = titleFie;
    self.navigationItem.titleView = titleView;
    
    self.searchTab.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchClick];
    return YES;
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
    self.view.userInteractionEnabled = NO;
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
            self.view.userInteractionEnabled = YES;
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
    if (self.back) {
        self.back(cus);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
