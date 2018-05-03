//
//  ConfirmOrderVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ConfirmOrderVC.h"
#import "ConfirmOrdHeadView.h"
#import "ConfirmOrdCell.h"
#import "PayViewController.h"
#import "ChooseAddressVC.h"
#import "OrderListInfo.h"
#import "AddressInfo.h"
#import "DetailTypeInfo.h"
#import "SearchCustomerVC.h"
#import "CustomerInfo.h"
#import "StrWithIntTool.h"
#import "CustomProDetailVC.h"
#import "OrderPriceInfo.h"
#import "OrderNewInfo.h"
#import "ConfirmEditHeadView.h"
#import "InvoiceViewController.h"
#import "ProductionOrderVC.h"
#import "CustomPickView.h"
#import "OrderListController.h"
#import "NewCustomProDetailVC.h"
#import "NewCustomizationVC.h"
#import "StatisticNumberVC.h"
@interface ConfirmOrderVC ()<UITableViewDelegate,UITableViewDataSource,
                            ConfirmOrdHeadViewDelegate,ConfirmOrdCellDelegate>{
    int curPage;
    int pageCount;
    int totalCount;//商品总数量
}
@property (weak, nonatomic) ConfirmOrdHeadView *headView;
@property (weak, nonatomic) IBOutlet UIButton *conBtn;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIButton *depositBtn;
@property (weak, nonatomic) IBOutlet UILabel *totleLab;
@property (weak, nonatomic) IBOutlet UILabel *deposLab;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UIButton *deleBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) UIButton *topBtn;
@property (weak, nonatomic) ConfirmEditHeadView *headEView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *selectDataArray;
@property (nonatomic,strong)NSArray *qualityArr;
@property (nonatomic,strong)NSArray *colorArr;
@property (nonatomic,strong)NSArray *priceArr;
@property (nonatomic,strong)DetailTypeInfo *invoInfo;
@property (nonatomic,strong)DetailTypeInfo *qualityInfo;
@property (nonatomic,strong)DetailTypeInfo *colorInfo;
@property (nonatomic,strong)CustomerInfo *cusInfo;
@property (nonatomic,strong)AddressInfo *addressInfo;
@property (nonatomic,  weak)CustomPickView *pickView;
@property (nonatomic,assign)BOOL isShow;
@property (nonatomic,assign)BOOL isSelBtn;
@property (nonatomic,assign)CGFloat headH;
@end

@implementation ConfirmOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    pageCount = 12;
    self.isShow = [[AccountTool account].isNoShow intValue]||
    [[AccountTool account].isNoDriShow intValue];
    [self creatConfirmOrder];
}

- (void)creatConfirmOrder{
    self.priceLab.hidden = self.isShow;
    self.conBtn.enabled = !self.isShow;
    [self changeHeightWithDev];
    [self setupTableView];
    [self creatHeadView];
    self.dataArray = @[].mutableCopy;
    self.selectDataArray = @[].mutableCopy;
    [self.conBtn setLayerWithW:5 andColor:BordColor andBackW:0.0001];
    [self setupPopView];
    if (self.editId) {
        self.title = @"订单详情";
        self.bottomView.hidden = YES;
        [self.depositBtn setLayerWithW:5 andColor:BordColor andBackW:0.0001];
        [self.conBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [self loadEditData];
        [self setupTableHeadView];
    }else{
        self.title = @"确认订单";
        self.secondView.hidden = YES;
        [self setupHeaderRefresh];
        [self creatNearNetView:^(BOOL isWifi) {
            [self.tableView.mj_header beginRefreshing];
        }];
        [self creatNaviBtn];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    if (self.isOrd) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_return"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
}

- (void)back{
    OrderListController *listVC = [OrderListController new];
    listVC.isOrd = self.isOrd;
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)creatNaviBtn{
    [self.deleBtn setLayerWithW:3 andColor:BordColor andBackW:0.5];
    [self.clearBtn setLayerWithW:3 andColor:BordColor andBackW:0.5];
    UIView *right = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 26)];
    UIButton *btn1 = [self creatBtnWith:@"编辑" andSel:@"完成"];
    btn1.frame = CGRectMake(0, 0, 45, 26);
    btn1.tag = 11;
    [right addSubview:btn1];
    
    UIButton *btn2 = [self creatBtnWith:@"统计" andSel:@""];
    btn2.frame = CGRectMake(45, 0, 45, 26);
    btn2.tag = 12;
    [right addSubview:btn2];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:right];
}

- (UIButton *)creatBtnWith:(NSString *)title andSel:(NSString *)selTitle{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    if (selTitle.length>0) {
        [btn setTitle:selTitle forState:UIControlStateSelected];
    }
    [btn addTarget:self action:@selector(changeEditView:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)changeEditView:(UIButton *)btn{
    if (btn.tag==11) {
        btn.selected = !btn.selected;
        self.editView.hidden = !btn.selected;
    }else{
        StatisticNumberVC *numVc = [StatisticNumberVC new];
        [self.navigationController pushViewController:numVc animated:YES];
    }
}

- (void)orientChange:(NSNotification *)notification{
    [self changeHeightWithDev];
    if (!self.topBtn.selected) {
        [self.topBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(self.headH);
        }];
    }
}

- (void)changeHeightWithDev{
    self.headH = 375;
    BOOL isDev = SDevWidth>SDevHeight;
    if (isDev&&IsPhone) {
        self.headH = 200;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isSelBtn = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.headView.customerFie resignFirstResponder];
}
#pragma mark -- creatTable
- (void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = DefaultColor;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(40);
        make.bottom.equalTo(self.view).offset(-50);
        make.right.equalTo(self.view).offset(0);
    }];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)setupTableHeadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 110)];
    headView.backgroundColor = DefaultColor;
    ConfirmEditHeadView *headV = [ConfirmEditHeadView createHeadView];
    [headView addSubview:headV];
    [headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(0);
        make.top.equalTo(headView).offset(10);
        make.bottom.equalTo(headView).offset(0);
        make.right.equalTo(headView).offset(0);
    }];
    self.tableView.tableHeaderView = headView;
    self.headEView = headV;
}

#pragma mark -- HeadView
- (void)creatHeadView{
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headBtn setLayerWithW:0.1 andColor:DefaultColor andBackW:0.8];
    [headBtn setImage:[UIImage imageNamed:@"icon_up"] forState:UIControlStateNormal];
    [headBtn setImage:[UIImage imageNamed:@"icon_downp"] forState:UIControlStateSelected];
    headBtn.backgroundColor = CUSTOM_COLOR(245, 245, 247);
    [headBtn addTarget:self action:@selector(btnShow:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBtn];
    [headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(@40);
    }];
    
    ConfirmOrdHeadView *view = [ConfirmOrdHeadView view];
    view.delegate = self;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.bottom.equalTo(headBtn.mas_top).with.offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
    }];
    
    self.headView = view;
    self.topBtn = headBtn;
    self.topBtn.selected = YES;
}

- (void)dismissHeadView{
    [UIView animateWithDuration:1 animations:^{
        self.topBtn.selected = YES;
        [self.topBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
        }];
    }];
}

- (void)showHeadView{
    [UIView animateWithDuration:1 animations:^{
        self.topBtn.selected = NO;
        [self.topBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(self.headH);
        }];
    }];
}

- (void)btnShow:(UIButton *)btn{
    if (!self.topBtn.selected) {
        [self dismissHeadView];
    }else{
        [self showHeadView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (!self.headView.hidden) {
        [self dismissHeadView];
    }
}

#pragma mark -- CustomPopView
- (void)setupPopView{
    CustomPickView *popV = [[CustomPickView alloc]init];
    popV.popBack = ^(int staue,id dict){
        [self chooseHeadView:dict];
        [self dismissCustomPopView];
    };
    [self.view addSubview:popV];
    [popV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.pickView = popV;
    [self dismissCustomPopView];
}

- (void)showCustomPopView{
    self.pickView.hidden = NO;
}

- (void)dismissCustomPopView{
    self.pickView.hidden = YES;
}

//选择成色与质量
- (void)chooseHeadView:(NSDictionary *)dict{
    NSIndexPath *path = [dict allKeys][0];
    DetailTypeInfo *info = [dict allValues][0];
    if (info.title.length==0) {
        return;
    }
    if (path.section==2) {
        self.qualityInfo = info;
        self.headView.qualityMes = info.title;
    }else{
        self.colorInfo = info;
        self.headView.colorMes = info.title;
        [self changeColorInfo:info];
    }
    [self editColorAndQuality];
}
//批量更改成色
- (void)changeColorInfo:(DetailTypeInfo *)cInfo{
    if (self.editId) {
        return;
    }
    NSArray *dataArr;
    NSString *mess;
    if (self.selectDataArray.count>0) {
        dataArr = self.selectDataArray;
        mess = [NSString stringWithFormat:@"是否把勾选的%d个商品都选为%@",
                (int)dataArr.count,cInfo.title];
    }else{
        dataArr = self.dataArray;
        mess = [NSString stringWithFormat:@"是否把当前的%d个商品都选为%@",
                (int)dataArr.count,cInfo.title];
    }
    NSMutableArray *mutA = @[].mutableCopy;
    for (OrderListInfo *collInfo in dataArr) {
        [mutA addObject:@(collInfo.id)];
    }
    [NewUIAlertTool show:mess okBack:^{
        NSString *netUrl = [NSString stringWithFormat:@"%@BathModifyPurityDo",baseUrl];
        NSMutableDictionary *params = [NSMutableDictionary new];
        params[@"tokenKey"] = [AccountTool account].tokenKey;
        params[@"itemIds"] = [StrWithIntTool strWithIntArr:mutA];
        params[@"purityId"] = @(self.colorInfo.id);
        [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
            if ([response.error intValue]==0) {
                for (OrderListInfo *collInfo in dataArr) {
                    collInfo.purityName = cInfo.title;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }else{
                [MBProgressHUD showError:response.message];
            }
        } requestURL:netUrl params:params];
    } andView:self.view yes:YES];
}
//选择客户
- (void)setCusInfo:(CustomerInfo *)cusInfo{
    if (cusInfo) {
        _cusInfo = cusInfo;
        self.headView.customerFie.text = cusInfo.customerName;
        if (self.editId) {
            [self editCustomer];
        }
    }
}
//选择地址
- (void)setAddressInfo:(AddressInfo *)addressInfo{
    if (addressInfo) {
        _addressInfo = addressInfo;
        self.headView.addInfo = _addressInfo;
    }
}
//更新价格
- (void)loadUpOrderPrice{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    NSString *httpStr;
    if (self.editId) {
        httpStr = @"ModelOrderWaitCheckModifyGetOrderPricePageListDo";
        params[@"orderId"] = @(self.editId);
    }else{
        httpStr = @"GetOrderPricePageList";
        params[@"cpage"] = @(curPage-1);
        if (!self.qualityInfo||!self.colorInfo) {
            return;
        }
    }
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@%@",baseUrl,httpStr];
    if (self.qualityInfo){
        params[@"qualityId"] = @(_qualityInfo.id);
    }
    if (self.colorInfo) {
        params[@"purityId"] = @(_colorInfo.id);
    }
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0&&[YQObjectBool boolForObject:response.data]) {
            NSArray *arr = [OrderPriceInfo mj_objectArrayWithKeyValuesArray:response.data[@"priceList"]];
            if (self.selectDataArray.count) {
                for (OrderListInfo *selist in self.selectDataArray) {
                    [self changePriceWithArr:arr andInfo:selist];
                }
                [self syncPriceLabel];
            }else{
                [self changePriceWithArr:arr andInfo:nil];
                if (self.editId) {
                    [self syncPriceLabel];
                }
            }
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:response.message];
        }
    } requestURL:regiUrl params:params];
}

- (void)changePriceWithArr:(NSArray *)arr andInfo:(OrderListInfo *)orderInfo{
    if (arr.count==0) {
        return;
    }
    for (int i=0; i<self.dataArray.count; i++) {
        OrderListInfo *list = self.dataArray[i];
        OrderPriceInfo *priceI = arr[i];
        list.price = priceI.price;
        list.needPayPrice = priceI.needPayPrice;
        if (orderInfo&&(orderInfo.id==priceI.id)) {
            orderInfo.price = priceI.price;
        }
    }
}
#pragma mark -- 未审核网络请求
- (void)loadEditData{
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"orderId"] = @(self.editId);
    NSString *url = [NSString stringWithFormat:@"%@ModelOrderWaitCheckDetail",baseUrl];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [self setupFootRefresh];
            if ([YQObjectBool boolForObject:response.data]){
                [self setupDataWithDict:response.data];
                [self setupListDataWithDict:response.data[@"currentOrderlList"]];
                BOOL isPay = [response.data[@"isNeetPay"]boolValue];
                self.depositBtn.hidden = !isPay;
                [self.tableView reloadData];
            }
            [SVProgressHUD dismiss];
        }
    } requestURL:url params:params];
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
    _tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupFootRefresh{
    
    MJRefreshAutoNormalFooter*footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
    [footer setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"好了，可以放松一下手指" forState:MJRefreshStatePulling];
    [footer setTitle:@"努力加载中，请稍候" forState:MJRefreshStateRefreshing];
    _tableView.mj_footer = footer;
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
        [self.selectDataArray removeAllObjects];
    }
    self.allBtn.selected = NO;
    [self syncPriceLabel];
    [self getCommodityData];
}
#pragma mark - 网络数据
- (void)getCommodityData{
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"cpage"] = @(curPage);
    params[@"pageNum"] = @(pageCount);
    if (self.qualityInfo){
        params[@"qualityId"] = @(self.qualityInfo.id);
    }
    if (self.colorInfo) {
        params[@"purityId"] = @(self.colorInfo.id);
    }
    self.view.userInteractionEnabled = NO;
    NSString *url = [NSString stringWithFormat:@"%@OrderListPage",baseUrl];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([response.error intValue]==0) {
            [self setupFootRefresh];
            if ([YQObjectBool boolForObject:response.data]){
                [self setupDataWithDict:response.data];
                [self setupListDataWithDict:response.data[@"currentOrderlList"]];
                [self.tableView reloadData];
                self.view.userInteractionEnabled = YES;
            }
            [SVProgressHUD dismiss];
        }
    } requestURL:url params:params];
}
//更新数据
- (void)setupDataWithDict:(NSDictionary *)dict{
    if ([YQObjectBool boolForObject:dict[@"address"]]&&!self.addressInfo) {
        self.addressInfo = [AddressInfo mj_objectWithKeyValues:
                            dict[@"address"]];
    }
    if (dict[@"customer"]&&!self.cusInfo) {
        self.cusInfo = [CustomerInfo mj_objectWithKeyValues:
                        dict[@"customer"]];
    }
    if ([YQObjectBool boolForObject:dict[@"modelColor"]]) {
        self.colorArr = dict[@"modelColor"];
    }
    if ([YQObjectBool boolForObject:dict[@"modelQuality"]]) {
        self.qualityArr = dict[@"modelQuality"];
    }
    if ([YQObjectBool boolForObject:dict[@"defaultValue"]]) {
        if (!self.qualityInfo) {
            self.qualityInfo = [DetailTypeInfo mj_objectWithKeyValues:
                                dict[@"defaultValue"][@"modelQuality"]];
            self.headView.qualityMes = self.qualityInfo.title;
        }
        if (!self.colorInfo) {
            self.colorInfo = [DetailTypeInfo mj_objectWithKeyValues:
                              dict[@"defaultValue"][@"modelColor"]];
            self.headView.colorMes = self.colorInfo.title;
        }
    }
    if (self.editId&&dict[@"orderInfo"]&&dict[@"totalPrice"]&&dict[@"totalNeedPayPrice"]) {
        OrderNewInfo *orderInfo = [OrderNewInfo mj_objectWithKeyValues:dict[@"orderInfo"]];
        self.headView.orderInfo = orderInfo;
        self.colorInfo = [DetailTypeInfo new];
        self.colorInfo.title = orderInfo.purityName;
        self.headEView.staueInfo = orderInfo;
        self.invoInfo = [DetailTypeInfo new];
        self.invoInfo.price = orderInfo.invoiceTitle;
        self.invoInfo.title = orderInfo.invoiceType;
        
        NSString *price = [OrderNumTool strWithPrice:[dict[@"totalPrice"]floatValue]];
        self.totleLab.text = [NSString stringWithFormat:@"参考总价:%@",price];
        NSString *dePrice = [OrderNumTool strWithPrice:[dict[@"totalNeedPayPrice"]floatValue]];
        self.deposLab.text = [NSString stringWithFormat:@"定金:%@",dePrice];
    }
}
//更新list数据
- (void)setupListDataWithDict:(NSDictionary *)dicList{
    if([YQObjectBool boolForObject:dicList[@"list"]]){
        self.tableView.mj_footer.state = MJRefreshStateIdle;
        curPage++;
        totalCount = [dicList[@"list_count"]intValue];
        NSArray *seaArr = [OrderListInfo mj_objectArrayWithKeyValuesArray:dicList[@"list"]];
        [_dataArray addObjectsFromArray:seaArr];
        if(_dataArray.count>=totalCount){
            //已加载全部数据
            MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_tableView.mj_footer;
            [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }else{
        //[self.tableView.header removeFromSuperview];
        MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_tableView.mj_footer;
        [footer setTitle:@"暂时没有商品" forState:MJRefreshStateNoMoreData];
        _tableView.mj_footer.state = MJRefreshStateNoMoreData;
    }
}

#pragma mark -- 头视图的点击事件 HeadViewDelegate
- (void)btnClick:(ConfirmOrdHeadView *)headView andIndex:(NSInteger)index andMes:(NSString *)mes{
    switch (index) {
        case 0:{
            [self pushEditVC];
        }
            break;
        case 1:{
            if (self.isSelBtn) {
                return;
            }
            [self pushSearchVC];
        }
            break;
        case 4:{
            [self pushInvoiceVc];
        }
            break;
        case 5:{
            [self loadHaveCustomer:mes];
        }
            break;
        case 6:{
            [self editWord];
        }
            break;
        case 7:{
            [self editNote];
        }
            break;
        default:{
            [self openPopTableWithInPath:index];
        }
            break;
    }
}

- (void)pushEditVC{
    ChooseAddressVC *editVc = [ChooseAddressVC new];
    editVc.addBack = ^(AddressInfo *info){
        self.addressInfo = info;
        if (self.editId) {
            [self editAddress];
        }
    };
    [self.navigationController pushViewController:editVc animated:YES];
}

- (void)pushSearchVC{
    SearchCustomerVC *cusVc = [SearchCustomerVC new];
    cusVc.searchMes = self.headView.customerFie.text;
    cusVc.back = ^(id dict){
        self.cusInfo = dict;
    };
    [self.navigationController pushViewController:cusVc animated:YES];
}

- (void)pushInvoiceVc{
    InvoiceViewController *InvoVc = [InvoiceViewController new];
    InvoVc.invoInfo = self.invoInfo;
    InvoVc.invoBack = ^(id dict){
        self.invoInfo = dict;
        if (self.invoInfo.price) {
            NSString *invoStr = [NSString stringWithFormat:@"类型:%@ 抬头:%@",
                                  self.invoInfo.title,self.invoInfo.price];
            self.headView.invoMes = invoStr;
        }else{
            self.headView.invoMes = self.invoInfo.title;
        }
        if (self.editId) {
            [self editInvoice];
        }
    };
    [self.navigationController pushViewController:InvoVc animated:YES];
}

- (void)loadHaveCustomer:(NSString *)message{
    if (self.isSelBtn) {
        return;
    }
    self.isSelBtn = YES;
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@IsHaveCustomer",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"keyword"] = message;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        self.isSelBtn = NO;
        if ([response.error intValue]==0&&[YQObjectBool boolForObject:response.data]) {
            if ([response.data[@"state"]intValue]==0) {
                SHOWALERTVIEW(@"没有此客户记录");
                self.headView.customerFie.text = @"";
                self.cusInfo.customerID = 0;
            }else if([response.data[@"state"]intValue]==1){
                self.cusInfo = [CustomerInfo mj_objectWithKeyValues:response.data[@"customer"]];
            }else if ([response.data[@"state"]intValue]==2){
                [self pushSearchVC];
            }
        }else{
            [MBProgressHUD showError:response.message];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (void)openPopTableWithInPath:(NSInteger)index{
    if (index==2) {
        if (self.qualityArr.count==0) {
            [MBProgressHUD showError:@"暂无数据"];
            return;
        }
        self.pickView.titleStr = @"质量等级";
        self.pickView.typeList = self.qualityArr;
        self.pickView.selTitle = self.qualityInfo.title;
    }else{
        if (self.colorArr.count==0) {
            [MBProgressHUD showError:@"暂无数据"];
            return;
        }
        self.pickView.titleStr = @"成色";
        self.pickView.typeList = self.colorArr;
        self.pickView.selTitle = self.colorInfo.title;
    }
    self.pickView.staue = 1;
    NSIndexPath *inPath = [NSIndexPath indexPathForRow:0 inSection:index];
    self.pickView.section = inPath;
    [self showCustomPopView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissCustomPopView];
}
#pragma mark 修改未审核订单信息
- (void)editAddress{
    NSString *str = @"ModelOrderWaitCheckDetailModifyAddressDo";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"orderId"] = @(self.editId);
    params[@"addressId"] = @(self.addressInfo.id);
    [self editOrderWithDic:params andStr:str];
}

- (void)editCustomer{
    NSString *str = @"ModelOrderWaitCheckDetailModifyInfoDo";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"orderId"] = @(self.editId);
    params[@"customerId"] = @(_cusInfo.customerID);
    [self editOrderWithDic:params andStr:str];
}

- (void)editColorAndQuality{
    if (!self.editId) {
        return;
    }
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    NSString *httpStr = @"ModelOrderWaitCheckModifyGetOrderPricePageListDo";
    params[@"orderId"] = @(self.editId);
    NSString *regiUrl = [NSString stringWithFormat:@"%@%@",baseUrl,httpStr];
    if (self.qualityInfo){
        params[@"qualityId"] = @(_qualityInfo.id);
    }
    if (self.colorInfo) {
        params[@"purityId"] = @(_colorInfo.id);
    }
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:@"更新信息成功"];
            if (self.boolBack) {
                self.boolBack(NO);
            }
        }else{
            [MBProgressHUD showError:response.message];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (void)editWord{
    if (!self.editId) {
        return;
    }
    NSString *str = @"ModelOrderWaitCheckDetailModifyInfoDo";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"orderId"] = @(self.editId);
    params[@"word"] = self.headView.wordFie.text;
    [self editOrderWithDic:params andStr:str];
}

- (void)editNote{
    if (!self.editId) {
        return;
    }
    NSString *str = @"ModelOrderWaitCheckDetailModifyInfoDo";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"orderId"] = @(self.editId);
    params[@"orderNote"] = self.headView.noteFie.text;
    [self editOrderWithDic:params andStr:str];
}

- (void)editInvoice{
    if (!self.editId) {
        return;
    }
    NSString *str = @"ModelOrderWaitCheckDetailModifyInfoDo";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"orderId"] = @(self.editId);
    if (self.invoInfo.price.length>0) {
        params[@"invTitle"] = self.invoInfo.price;
        params[@"invType"] = @(self.invoInfo.id);
    }else{
        params[@"invTitle"] = @"";
        params[@"invType"] = @(-1);
    }
    [self editOrderWithDic:params andStr:str];
}

- (void)editOrderWithDic:(NSMutableDictionary *)params andStr:(NSString *)str{
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@%@",baseUrl,str];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:@"更新信息成功"];
            if (self.boolBack) {
                self.boolBack(NO);
            }
        }else{
            [MBProgressHUD showError:response.message];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

#pragma mark -- tableViewDelegate
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
    ConfirmOrdCell *ordCell = [ConfirmOrdCell cellWithTableView:tableView];
    ordCell.tag = indexPath.section;
    ordCell.delegate = self;
    OrderListInfo *listI;
    if (indexPath.section < self.dataArray.count)
    {
        listI = self.dataArray[indexPath.section];
    }
    ordCell.isBtnHidden = self.editId;
    ordCell.listInfo = listI;
    ordCell.isShow = self.isShow;
    return ordCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self editIndex:indexPath.section];
}

#pragma mark -- cell中的按钮点击
- (void)btnCellClick:(ConfirmOrdCell *)headView andIndex:(NSInteger)index{
    NSInteger ind = headView.tag;
    switch (index) {
        case 0:
            [self selectBtnClick:ind];
            break;
        case 1:
            [self editIndex:ind];
            break;
        case 2:
            [self deleteIndex:ind];
            break;
        default:
            break;
    }
}
//勾选
- (void)selectBtnClick:(NSInteger )indx
{
    if (indx < self.dataArray.count)
    {
        OrderListInfo *OrderListInfo = self.dataArray[indx];
        if (OrderListInfo.isSel == YES)
        {
            [self.selectDataArray removeObject:OrderListInfo];
             self.allBtn.selected = NO;
        }else{
            [self.selectDataArray addObject:OrderListInfo];
        }
        OrderListInfo.isSel = !OrderListInfo.isSel;
        if ([self isAllYes]) {
            self.allBtn.selected = YES;
        }
        //同步显示
        [self syncPriceLabel];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:indx];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (BOOL)isAllYes {
    if (_dataArray.count>0) {
        for (OrderListInfo *OrderListInfo in _dataArray) {
            if (!OrderListInfo.isSel) {
                return NO;
            }
        }
    }
    return YES;
}
//编辑
- (void)editIndex:(NSInteger)index{
    OrderListInfo *collectInfo;
    if (index < self.dataArray.count)
    {
        collectInfo = self.dataArray[index];
    }
    if (collectInfo.showPageType) {
        [self gotoNewCustomizationVC:collectInfo idx:index];
        return;
    }
    if ([[AccountTool account].isNorm intValue]==0) {
        NewCustomProDetailVC *newVc = [NewCustomProDetailVC new];
        newVc.isCus = NO;
        if (self.editId) {
            newVc.isEdit = 2;
            if (self.colorInfo.title>0) {
                newVc.colorInfo = self.colorInfo;
            }
        }else{
            newVc.isEdit = 1;
        }
        newVc.proId = collectInfo.id;
        newVc.orderBack = ^(OrderListInfo *dict){
            [self detailOrderBack:dict andIdx:index];
        };
        [self.navigationController pushViewController:newVc animated:YES];
    }else{
        CustomProDetailVC *detailVc = [CustomProDetailVC new];
        detailVc.isEdit = self.editId?2:1;
        detailVc.proId = collectInfo.id;
        detailVc.orderBack = ^(OrderListInfo *dict){
            [self detailOrderBack:dict andIdx:index];
        };
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

- (void)gotoNewCustomizationVC:(OrderListInfo *)info idx:(NSInteger)index{
    NewCustomizationVC *detailVc = [NewCustomizationVC new];
    detailVc.isEd = 2;
    detailVc.proId = info.id;
    detailVc.back = ^(OrderListInfo *dict){
        [self detailOrderBack:dict andIdx:index];
    };
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)detailOrderBack:(OrderListInfo *)dict andIdx:(NSInteger)index{
    OrderListInfo *collectInfo;
    if (index < self.dataArray.count)
    {
        collectInfo = self.dataArray[index];
    }
    if (![dict isKindOfClass:[OrderListInfo class]]) {
        return;
    }
    self.dataArray[index] = dict;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
    self.allBtn.selected = NO;
    if ([self.selectDataArray containsObject:collectInfo]){
        [self.selectDataArray removeObject:collectInfo];
    }
    [self syncPriceLabel];
}
//删除
- (void)deleteIndex:(NSInteger)index{
    OrderListInfo *collectInfo;
    if (index < self.dataArray.count)
    {
        collectInfo = self.dataArray[index];
    }
    NSString *httpStr;
    if (self.editId) {
        httpStr = @"ModelOrderWaitCheckDetailDeleteModelItemDo";
        if (self.dataArray.count==1) {
            [MBProgressHUD showError:@"请点取消订单"];
            return;
        }
    }else{
        httpStr = @"OrderCurrentDeleteModelItemDo";
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,httpStr];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"itemId"] = @(collectInfo.id);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:response.message];
            if ([YQObjectBool boolForObject:response.data]&&
                [YQObjectBool boolForObject:response.data[@"waitOrderCount"]]) {
                App;
                app.shopNum = [response.data[@"waitOrderCount"]intValue];
            }
        }else{
            [MBProgressHUD showError:response.message];
        }
    } requestURL:url params:params];
    [self.dataArray removeObjectAtIndex:index];
    if ([self.selectDataArray containsObject:collectInfo])
    {
        [self.selectDataArray removeObject:collectInfo];
    }
    [self syncPriceLabel];
    [self.tableView reloadData];
}
#pragma mark -- 底部的价格与按钮
//更新价格
- (void)syncPriceLabel{
    double value = 0.0;
    if (!self.editId) {
        NSString *conStr = @"确定";
        NSString *deleStr = @"删除";
        if (_selectDataArray.count){
            for (OrderListInfo *collectInfo in _selectDataArray){
                value = value+collectInfo.price;
            }
            NSString *cou = [NSString stringWithFormat:@"(%d)",(int)_selectDataArray.count];
            conStr = [conStr stringByAppendingString:cou];
            deleStr = [deleStr stringByAppendingString:cou];
        }
        NSString *price = [OrderNumTool strWithPrice:value];
        self.priceLab.text = [NSString stringWithFormat:@"参考总价:%@",price];
        [self.conBtn setTitle:conStr forState:UIControlStateNormal];
        [self.deleBtn setTitle:deleStr forState:UIControlStateNormal];
    }else{
        double needValue = 0.0;
        if (_dataArray.count){
            for (OrderListInfo *collectInfo in _dataArray)
            {
                value = value+collectInfo.price;
                needValue = needValue+collectInfo.needPayPrice;
            }
        }
        NSString *price = [OrderNumTool strWithPrice:value];
        self.totleLab.text = [NSString stringWithFormat:@"参考总价:%@",price];
        NSString *dePrice = [OrderNumTool strWithPrice:needValue];
        self.deposLab.text = [NSString stringWithFormat:@"定金:%@",dePrice];
        if (self.boolBack) {
            self.boolBack(NO);
        }
    }
}
//底部按钮
- (IBAction)chooseClick:(UIButton *)sender {
    if (sender.selected == NO)
    {
        [self.selectDataArray removeAllObjects];
        [self.selectDataArray addObjectsFromArray:self.dataArray];
        for (OrderListInfo *collInfo in self.dataArray) {
            collInfo.isSel = YES;
        }
        sender.selected = YES;
    }else{
        for (OrderListInfo *collInfo in self.dataArray) {
            collInfo.isSel = NO;
        }
        sender.selected = NO;
        [self.selectDataArray removeAllObjects];
    }
    [self syncPriceLabel];
    [self.tableView reloadData];
}

- (IBAction)payPrice:(id)sender {
    PayViewController *payVc = [PayViewController new];
    payVc.orderId = [NSString stringWithFormat:@"%d",self.editId];
    [self.navigationController pushViewController:payVc animated:YES];
}

- (IBAction)confirmClick:(id)sender {
    if (self.editId) {
        [self cancelOrder];
    }else{
        self.conBtn.enabled = NO;
        [self performSelector:@selector(changeButtonStatus)withObject:nil
                   afterDelay:2.0f];//防止重复点击
        [self confirmOrder];
    }
}

- (void)changeButtonStatus{
    self.conBtn.enabled = YES;
}
//提交订单
- (void)confirmOrder{
    if (!self.addressInfo) {
        [MBProgressHUD showError:@"请选择地址"];
        if (self.topBtn.selected) {
            [self showHeadView];
        }
        return;
    }
    if (self.cusInfo.customerID==0) {
        [MBProgressHUD showError:@"请选择客户信息"];
        if (self.topBtn.selected) {
            [self showHeadView];
        }
        return;
    }
    if (self.qualityInfo.id==0) {
        [MBProgressHUD showError:@"请选择质量等级"];
        if (self.topBtn.selected) {
            [self showHeadView];
        }
        return;
    }
//    if (self.colorInfo.id==0) {
//        [MBProgressHUD showError:@"请选择成色"];
//        if (self.topBtn.selected) {
//            [self showHeadView];
//        }
//        return;
//    }
    if (!self.selectDataArray.count) {
        [MBProgressHUD showError:@"请选择商品"];
        return;
    }
    [self submitOrdersNew];
}

- (void)submitOrdersNew{
    [SVProgressHUD show];
    NSMutableArray *mutArr = [NSMutableArray array];
    for (OrderListInfo *collInfo in _selectDataArray) {
        [mutArr addObject:@(collInfo.id)];
    }
    NSString *url = [NSString stringWithFormat:@"%@OrderCurrentSubmitsDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"itemId"] = [StrWithIntTool strWithIntArr:mutArr];
    params[@"addressId"] = @(self.addressInfo.id);
    params[@"qualityId"] = @(self.qualityInfo.id);
    if (self.headView.wordFie.text.length>0) {
        params[@"word"] = _headView.wordFie.text;
    }
    if (self.headView.noteFie.text.length>0) {
        params[@"orderNote"] = _headView.noteFie.text;
    }
    if (self.invoInfo.title.length>0) {
        params[@"invTitle"] = self.invoInfo.price;
        params[@"invType"] = @(self.invoInfo.id);
    }
    params[@"customerID"] = @(self.cusInfo.customerID);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:@"提交成功"];
            if ([YQObjectBool boolForObject:response.data]&&
                [YQObjectBool boolForObject:response.data[@"waitOrderCount"]]) {
                App;
                app.shopNum = [response.data[@"waitOrderCount"]intValue];
            }
            [self gotoListOrder:response.data];
        }else{
            [MBProgressHUD showError:response.message];
        }
    } requestURL:url params:params];
}
//直接跳到历史订单
- (void)gotoListOrder:(id)dic{
    dispatch_async(dispatch_get_main_queue(), ^{
        OrderListController *listVC = [OrderListController new];
        listVC.isOrd = YES;
        listVC.index = [dic[@"isCheckErpOrder"]intValue];
        [self.navigationController pushViewController:listVC animated:YES];
    });
}

//- (void)submitOrders{
//    NSMutableArray *mutArr = [NSMutableArray array];
//    for (OrderListInfo *collInfo in _selectDataArray) {
//        [mutArr addObject:@(collInfo.id)];
//    }
//    NSString *url = [NSString stringWithFormat:@"%@OrderCurrentSubmitDo",baseUrl];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"tokenKey"] = [AccountTool account].tokenKey;
//    params[@"itemId"] = [StrWithIntTool strWithIntArr:mutArr];
//    params[@"addressId"] = @(self.addressInfo.id);
//    params[@"purityId"] = @(self.colorInfo.id);
//    params[@"qualityId"] = @(self.qualityInfo.id);
//    if (self.headView.wordFie.text.length>0) {
//        params[@"word"] = _headView.wordFie.text;
//    }
//    if (self.headView.noteFie.text.length>0) {
//        params[@"orderNote"] = _headView.noteFie.text;
//    }
//    if (self.invoInfo.title.length>0) {
//        params[@"invTitle"] = self.invoInfo.price;
//        params[@"invType"] = @(self.invoInfo.id);
//    }
//    params[@"customerID"] = @(self.cusInfo.customerID);
//    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
//        if ([response.error intValue]==0) {
//            [MBProgressHUD showSuccess:@"提交成功"];
//            if ([YQObjectBool boolForObject:response.data]&&
//                [YQObjectBool boolForObject:response.data[@"waitOrderCount"]]) {
//                App;
//                app.shopNum = [response.data[@"waitOrderCount"]intValue];
//            }
//            [self gotoNextViewConter:response.data];
//            [self.tableView.mj_header beginRefreshing];
//        }else{
//            [MBProgressHUD showError:response.message];
//        }
//    } requestURL:url params:params];
//}
////是否需要付款 是否下单ERP
//- (void)gotoNextViewConter:(id)dic{
//    if ([dic[@"isNeetPay"]intValue]==1) {
//        PayViewController *payVc = [PayViewController new];
//        payVc.orderId = dic[@"orderNum"];
//        [self.navigationController pushViewController:payVc animated:YES];
//    }else{
//        if ([dic[@"isErpOrder"]intValue]==0) {
//            ConfirmOrderVC *oDetailVc = [ConfirmOrderVC new];
//            oDetailVc.isOrd = YES;
//            oDetailVc.editId = [dic[@"id"] intValue];
//            [self.navigationController pushViewController:oDetailVc animated:YES];
//        }else{
//            ProductionOrderVC *proVc = [ProductionOrderVC new];
//            proVc.isOrd = YES;
//            proVc.orderNum = dic[@"orderNum"];
//            [self.navigationController pushViewController:proVc animated:YES];
//        }
//    }
//    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray:
//                                       self.navigationController.viewControllers];
//    NSInteger index = self.navigationController.viewControllers.count;
//    [navigationArray removeObjectAtIndex: index-2];
//    self.navigationController.viewControllers = navigationArray;
//}

- (void)cancelOrder{
    NSString *url = [NSString stringWithFormat:@"%@ModelOrderWaitCheckCancelDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"orderId"] = @(self.editId);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:response.message];
            if (self.boolBack) {
                self.boolBack(YES);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:response.message];
        }
    } requestURL:url params:params];
}

- (IBAction)deleAllClick:(id)sender {
    if (_selectDataArray.count==0) {
        [MBProgressHUD showError:@"请选择商品"];
        return;
    }
    [NewUIAlertTool show:@"是否删除勾选商品" okBack:^{
        [SVProgressHUD show];
        NSString *netUrl = [NSString stringWithFormat:@"%@OrderCurrentDeleteModelItemsDo",baseUrl];
        NSMutableDictionary *params = [NSMutableDictionary new];
        params[@"tokenKey"] = [AccountTool account].tokenKey;
        NSMutableArray *mutArr = [NSMutableArray array];
        for (OrderListInfo *collInfo in _selectDataArray) {
            [mutArr addObject:@(collInfo.id)];
        }
        params[@"tokenKey"] = [AccountTool account].tokenKey;
        params[@"itemIds"] = [StrWithIntTool strWithArr:mutArr With:@","];
        [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
            if ([response.error intValue]==0) {
                [MBProgressHUD showError:response.message];
                [self.tableView.mj_header beginRefreshing];
            }else{
                [MBProgressHUD showError:response.message];
            }
        } requestURL:netUrl params:params];
    } andView:self.view yes:YES];
}

- (IBAction)clearAllClick:(id)sender {
    if (self.dataArray.count==0) {
        [MBProgressHUD showError:@"没有商品"];
        return;
    }
    [NewUIAlertTool show:@"是否清空当前订单" okBack:^{
        [SVProgressHUD show];
        NSString *netUrl = [NSString stringWithFormat:@"%@OrderCurrentDeleteModelClear",baseUrl];
        NSMutableDictionary *params = [NSMutableDictionary new];
        params[@"tokenKey"] = [AccountTool account].tokenKey;
        [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
            if ([response.error intValue]==0) {
                [MBProgressHUD showError:response.message];
                [self.tableView.mj_header beginRefreshing];
            }else{
                [MBProgressHUD showError:response.message];
            }
        } requestURL:netUrl params:params];
    } andView:self.view yes:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
