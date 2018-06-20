//
//  SearchOrderVc.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/14.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SearchOrderVc.h"
#import "CustomTextField.h"
#import "CustomDatePick.h"
#import "CustomBtnView.h"
#import "YQDropdownMenu.h"
#import "SearchResultsVC.h"
#import "SearchCustomerVC.h"
#import "CustomerInfo.h"
#import "StrWithIntTool.h"
#import "SearchHeadBtnView.h"
#import "ScreenDetailInfo.h"
#import "SearchOrderView.h"
#import "SearchDateInfo.h"
@interface SearchOrderVc ()<UITextFieldDelegate,YQDropdownMenuDelagate,
                                      UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet SearchOrderView *btnSeaView;
@property (nonatomic,  weak) UITextField *searchFie;
@property (nonatomic,  weak) UIButton *titleBtn;
@property (nonatomic,strong) CustomDatePick *datePickView;
@property (nonatomic,  weak) CustomBtnView *btnView;
@property (nonatomic,  weak) YQDropdownMenu *menufie;
@property (nonatomic,strong) NSMutableDictionary *dict;
@property (nonatomic,  copy) NSArray *textArr;
@property (nonatomic,assign) int isSel;
@property (nonatomic,assign) BOOL isSelBtn;
@property (nonatomic,strong) CustomerInfo *cusInfo;
@property (strong,nonatomic) IBOutletCollection(UIView) NSArray *dateViews;
@property (strong,nonatomic) IBOutletCollection(UIButton) NSArray *dateBtns;
@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak,  nonatomic) IBOutlet UITextField *textFie;
@property (weak, nonatomic) IBOutlet UIView *backFieView;
@end

@implementation SearchOrderVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单搜索";
    self.view.backgroundColor = DefaultColor;
    self.dict = [NSMutableDictionary new];
    [self setNaviTitleAndRight];
    [self.backFieView setLayerWithW:3 andColor:BordColor andBackW:0.5];
    for (UIView *baV in self.dateViews) {
        baV.layer.cornerRadius = 3;
    }
    [self loadSearchData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isSelBtn = NO;
}

#pragma mark -- NaviBarTitleView
- (void)setNaviTitleAndRight{
    CGFloat sWidth = 65;
    UIView *titleView = [[UIView alloc]init];
    [titleView setLayerWithW:3 andColor:BordColor andBackW:0.5];
    titleView.backgroundColor = DefaultColor;
    [self.topBackView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBackView).offset(92);
        make.top.equalTo(self.topBackView).offset(9);
        make.right.equalTo(self.topBackView).offset(-15);
        make.height.mas_equalTo(@30);
    }];
    
    CustomBtnView *btnV = [CustomBtnView creatView];
    btnV.frame = CGRectMake(5, 0, sWidth, 30);
    [btnV.selBtn setImage:[UIImage imageNamed:@"icon_xxx"] forState:UIControlStateNormal];
    [btnV.allBtn addTarget:self action:@selector(clickDown) forControlEvents:
                                                   UIControlEventTouchUpInside];
    [titleView addSubview:btnV];
    self.btnView = btnV;
    
    CustomTextField *titleFie = [[CustomTextField alloc]initWithFrame:CGRectZero];
    titleFie.tag = 1081;
    titleFie.delegate = self;
    titleFie.borderStyle = UITextBorderStyleNone;
    [titleView addSubview:titleFie];
    [titleFie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView).offset(sWidth+5);
        make.top.equalTo(titleView).offset(0);
        make.right.equalTo(titleView).offset(0);
        make.height.mas_equalTo(@30);
    }];
    _searchFie = titleFie;
    
    self.textFie.tag = 1082;
    __weak __typeof(&*self)weakSelf = self;
    self.btnSeaView.dateBack = ^(SearchDateInfo *info){
        [weakSelf setBtnData:info.sdate and:info.edate];
    };
}

- (void)loadSearchData{
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@ModelUserOrderSearchPage",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0&&[YQObjectBool boolForObject:response.data]) {
            [self setBaseViewData:response.data];
        }
    } requestURL:regiUrl params:params];
}

- (void)setBaseViewData:(NSDictionary *)dic{
    NSArray *arr = [ScreenDetailInfo objectArrayWithKeyValuesArray:dic[@"searchKeyword"]];
    NSArray *arrBtn = [ScreenDetailInfo objectArrayWithKeyValuesArray:dic[@"searchScope"]];
    NSArray *arrSea = [SearchDateInfo objectArrayWithKeyValuesArray:dic[@"searchDateScope"]];
    ScreenDetailInfo *sInfo= arr[0];
    ScreenDetailInfo *cInfo = arrBtn[0];
    self.dict[@"skeyid"] = @(sInfo.id);
    self.dict[@"sscopeid"] = @(cInfo.id);
    [self setBtnData:dic[@"startDate"] and:dic[@"endDate"]];
    self.textArr = arr;
    [self creatSearchBtn:arrBtn];
    self.btnView.titleLab.text = sInfo.title;
    self.btnSeaView.arr = arrSea;
}

- (void)setBtnData:(NSString *)sDate and:(NSString *)eDate{
    self.dict[@"sdate"] = sDate;
    self.dict[@"edate"] = eDate;
    UIButton *sBtn = self.dateBtns[0];
    [sBtn setTitle:self.dict[@"sdate"] forState:UIControlStateNormal];
    UIButton *eBtn = self.dateBtns[1];
    [eBtn setTitle:self.dict[@"edate"] forState:UIControlStateNormal];
}

- (void)creatSearchBtn:(NSArray *)arr{
    CGRect frame = CGRectMake(0, 196,SDevWidth , 60);
    SearchHeadBtnView *head = [[SearchHeadBtnView alloc]initWithFrame:frame withArr:arr];
    frame.size.height = head.height;
    head.frame = frame;
    [self.view addSubview:head];
    head.back = ^(id chId){
        self.dict[@"sscopeid"] = chId;
    };
    [self creatSeaBtn:head];
}

- (void)creatSeaBtn:(SearchHeadBtnView *)head{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setBackgroundColor:MAIN_COLOR];
    btn.layer.cornerRadius = 5;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(head.mas_bottom).with.offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(@40);
    }];
    [btn addTarget:self action:@selector(searchClick)
                                  forControlEvents:UIControlEventTouchUpInside];
     [self loadDatePick];
}

#pragma mark -- 导航点击事件
- (void)clickDown{
    CGFloat wid = self.textArr.count*24;
    YQDropdownMenu *menu = [YQDropdownMenu menu];
    menu.delegate = self;
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 70, wid)];
    table.backgroundColor = [UIColor clearColor];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    menu.content = table;
    [menu showFrom:self.btnView];
    self.menufie = menu;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.textArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 24.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"menuCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    }
    ScreenDetailInfo *info = self.textArr[indexPath.row];
    cell.textLabel.text = info.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ScreenDetailInfo *info = self.textArr[indexPath.row];
    self.dict[@"skeyid"] = @(info.id);
    [self.menufie dismiss];
    self.btnView.titleLab.text = info.title;
}

#pragma mark -- 日历选择
- (void)loadDatePick{
    CustomDatePick *datePick = [CustomDatePick creatCustomView];
    [self.view addSubview:datePick];
    [datePick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    datePick.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd";
    datePick.back = ^(NSDate *date){
        [self.btnSeaView setAllBtnSele];
        NSString *str = [formatter stringFromDate:date];
        UIButton *sBtn = self.dateBtns[self.isSel];
        [sBtn setTitle:str forState:UIControlStateNormal];
        if (self.isSel) {
            self.dict[@"edate"] = str;
        }else{
            self.dict[@"sdate"] = str;
        }
    };
    datePick.hidden = YES;
    self.datePickView = datePick;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.datePickView.hidden = YES;
}

- (IBAction)dateClick:(UIButton *)sender {
    NSInteger index = [self.dateBtns indexOfObject:sender];
    self.isSel = (int)index;
    NSString *str = index?self.dict[@"edate"]:self.dict[@"sdate"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd";
    [self.datePickView.datePick setDate:[formatter dateFromString:str] animated:YES];
    self.datePickView.hidden = NO;
}
#pragma mark 客户选择
- (IBAction)searchCustomer:(id)sender {
    [self.textFie resignFirstResponder];
    [self.searchFie resignFirstResponder];
    if (self.isSelBtn) {
        return;
    }
    [self pushSearchVC];
}

- (void)setCusInfo:(CustomerInfo *)cusInfo{
    if (cusInfo) {
        _cusInfo = cusInfo;
        self.textFie.text = cusInfo.customerName;
        self.dict[@"customerID"] = @(_cusInfo.customerID);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==1082) {
        NSMutableArray *addArr = @[].mutableCopy;
        if (textField.text.length>0) {
            NSArray *arr = [textField.text componentsSeparatedByString:@" "];
            for (NSString *str in arr) {
                if (![str isEqualToString:@""]) {
                    [addArr addObject:str];
                }
            }
            [self loadHaveCustomer:[StrWithIntTool strWithArr:addArr]];
        }else{
            [self.dict removeObjectForKey:@"customerID"];
        }
    }
}

- (void)pushSearchVC{
    SearchCustomerVC *cusVc = [SearchCustomerVC new];
    cusVc.searchMes = self.textFie.text;
    cusVc.back = ^(id dict){
        self.cusInfo = dict;
    };
    [self.navigationController pushViewController:cusVc animated:YES];
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
                self.cusInfo.customerID = 0;
            }else if([response.data[@"state"]intValue]==1){
                self.cusInfo = [CustomerInfo objectWithKeyValues:response.data[@"customer"]];
            }else if ([response.data[@"state"]intValue]==2){
                [self pushSearchVC];
            }
        }else{
            [MBProgressHUD showError:response.message];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (void)searchClick{
    [self.textFie resignFirstResponder];
    [self.searchFie resignFirstResponder];
    self.dict[@"keyword"] = self.searchFie.text;
    SearchResultsVC *resVc = [SearchResultsVC new];
    resVc.mutDic = self.dict.copy;
    [self.navigationController pushViewController:resVc animated:YES];
}

@end
