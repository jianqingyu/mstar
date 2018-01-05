//
//  NewCustomizationSureVC.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2017/12/13.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NewCustomizationSureVC.h"
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
#import "NewCustomizationVC.h"
#import "OrderListController.h"
#import "NewCustomProDetailVC.h"
@interface NewCustomizationSureVC ()<UITableViewDelegate,UITableViewDataSource,
ConfirmOrdHeadViewDelegate,ConfirmOrdCellDelegate>{
    int curPage;
    int pageCount;
    int totalCount;//商品总数量
}
@property (weak, nonatomic) ConfirmOrdHeadView *headView;
@property (weak, nonatomic) IBOutlet UIButton *conBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) UIButton *topBtn;
@property (weak, nonatomic) ConfirmEditHeadView *headEView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
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
@implementation NewCustomizationSureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShow = [[AccountTool account].isNoShow intValue]||
    [[AccountTool account].isNoDriShow intValue];
    [self creatConfirmOrder];
}

- (void)creatConfirmOrder{
    [self changeHeightWithDev];
    [self setupTableView];
    [self creatHeadView];
    self.dataArray = @[].mutableCopy;
    [self.conBtn setLayerWithW:5 andColor:BordColor andBackW:0.0001];
    [self setupPopView];
    self.title = @"确认订单";
    [self getCommodityData];
    [self creatNearNetView:^(BOOL isWifi) {
        [self.tableView.mj_header beginRefreshing];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
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
    }
    //    [self loadUpOrderPrice];
}
//选择客户
- (void)setCusInfo:(CustomerInfo *)cusInfo{
    if (cusInfo) {
        _cusInfo = cusInfo;
        self.headView.customerFie.text = cusInfo.customerName;
    }
}
//选择地址
- (void)setAddressInfo:(AddressInfo *)addressInfo{
    if (addressInfo) {
        _addressInfo = addressInfo;
        self.headView.addInfo = _addressInfo;
    }
}

#pragma mark - 网络数据
- (void)getCommodityData{
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    NSString *url = [NSString stringWithFormat:@"%@OrderListCustomPage",baseUrl];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data]){
                [self setupDataWithDict:response.data];
                [self.tableView reloadData];
            }
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
    if (dict[@"modelColor"]) {
        self.colorArr = dict[@"modelColor"];
    }
    if (dict[@"modelQuality"]) {
        self.qualityArr = dict[@"modelQuality"];
    }
    if ([YQObjectBool boolForObject:dict[@"defaultValue"]]) {
        if (!self.qualityInfo) {
            self.qualityInfo = [DetailTypeInfo mj_objectWithKeyValues:
                                dict[@"defaultValue"][@"modelQuality"]];
            if (self.qualityInfo.title.length==0) {
                self.qualityInfo = [DetailTypeInfo mj_objectWithKeyValues:self.qualityArr[0]];
            }
            self.headView.qualityMes = self.qualityInfo.title;
        }
        if (!self.colorInfo) {
            self.colorInfo = [DetailTypeInfo mj_objectWithKeyValues:
                              dict[@"defaultValue"][@"modelColor"]];
            self.headView.colorMes = self.colorInfo.title;
        }
    }
    if([YQObjectBool boolForObject:dict[@"currentOrderlList"][@"list"]]){
        NSArray *seaArr = [OrderListInfo mj_objectArrayWithKeyValuesArray:dict[@"currentOrderlList"][@"list"]];
        [_dataArray addObjectsFromArray:seaArr];
        OrderListInfo *info = seaArr[0];
        self.priceLab.text = [NSString stringWithFormat:@"￥%0.0f",info.price];
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
        case 6:
            break;
        case 7:
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

#pragma mark -- tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
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
    ordCell.isTopHidden = YES;
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
            break;
        case 1:
            [self editIndex:ind];
            break;
        case 2:
            break;
        default:
            break;
    }
}
//编辑
- (void)editIndex:(NSInteger)index{
    OrderListInfo *collectInfo = self.dataArray[0];
    NewCustomizationVC *cusVc = [NewCustomizationVC new];
    cusVc.isEd = 1;
    cusVc.proId = collectInfo.id;
    cusVc.back = ^(id model) {
        [self detailOrderBack:model];
    };
    [self.navigationController pushViewController:cusVc animated:YES];
}

- (void)detailOrderBack:(OrderListInfo *)dict{
    if (![dict isKindOfClass:[OrderListInfo class]]) {
        return;
    }
    self.priceLab.text = [NSString stringWithFormat:@"￥%0.0f",dict.price];
    self.dataArray[0] = dict;
    [self.tableView reloadData];
}

- (IBAction)confirmClick:(id)sender {
    self.conBtn.enabled = NO;
    [self performSelector:@selector(changeButtonStatus)withObject:nil afterDelay:1.0f];//防止重复点击
    [self confirmOrder];
}

- (void)changeButtonStatus{
    self.conBtn.enabled =YES;
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
        [MBProgressHUD showError:@"请客户信息"];
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
    if (self.colorInfo.id==0) {
        [MBProgressHUD showError:@"请选择成色"];
        if (self.topBtn.selected) {
            [self showHeadView];
        }
        return;
    }
    [self submitOrders];
}

- (void)submitOrders{
    NSMutableArray *mutArr = [NSMutableArray array];
    for (OrderListInfo *collectInfo in self.dataArray) {
        [mutArr addObject:@(collectInfo.id)];
    }
    NSString *url = [NSString stringWithFormat:@"%@OrderCurrentSubmitDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"itemId"] = [StrWithIntTool strWithIntArr:mutArr];
    params[@"addressId"] = @(self.addressInfo.id);
    params[@"purityId"] = @(self.colorInfo.id);
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
            [self gotoNextViewConter:response.data];
        }else{
            [MBProgressHUD showError:response.message];
        }
    } requestURL:url params:params];
}
//是否需要付款 是否下单ERP
- (void)gotoNextViewConter:(id)dic{
    if ([dic[@"isNeetPay"]intValue]==1) {
        PayViewController *payVc = [PayViewController new];
        payVc.orderId = dic[@"orderNum"];
        [self.navigationController pushViewController:payVc animated:YES];
    }else{
        if ([dic[@"isErpOrder"]intValue]==0) {
            ConfirmOrderVC *oDetailVc = [ConfirmOrderVC new];
            oDetailVc.isOrd = YES;
            oDetailVc.editId = [dic[@"id"] intValue];
            [self.navigationController pushViewController:oDetailVc animated:YES];
        }else{
            ProductionOrderVC *proVc = [ProductionOrderVC new];
            proVc.isOrd = YES;
            proVc.orderNum = dic[@"orderNum"];
            [self.navigationController pushViewController:proVc animated:YES];
        }
    }
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray:
                                       self.navigationController.viewControllers];
    NSInteger index = self.navigationController.viewControllers.count;
    [navigationArray removeObjectAtIndex: index-2];
    self.navigationController.viewControllers = navigationArray;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
