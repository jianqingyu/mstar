//
//  InvoiceViewController.m
//  MillenniumStarERP
//
//  Created by yjq on 16/12/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "InvoiceViewController.h"

#import "ChooseInvoiceCell.h"
@interface InvoiceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *nameFie;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *tableFView;
@property (nonatomic,copy)NSArray *invoArr;
@property (nonatomic,assign)int inId;
@end

@implementation InvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发票";
    self.nameFie.text = self.invoInfo.price;
    [self setupDataView];
    [self loadInvoData];
}

- (void)setupDataView{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(120);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(@40);
    }];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, DevWidth-30, 20)];
    title.text = @"发票内容";
    title.font = [UIFont systemFontOfSize:16];
    [footView addSubview:title];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 39, DevWidth-30, 1)];
    line.backgroundColor = DefaultColor;
    [footView addSubview:line];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [footView addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView).offset(40);
        make.left.equalTo(footView).offset(0);
        make.right.equalTo(footView).offset(0);
        make.bottom.equalTo(footView).offset(0);
    }];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableFView = footView;
}

- (void)loadInvoData{
    [SVProgressHUD show];
    NSString *str = self.isStone?@"StoneInvoicePage":@"ModelInvoicePage";
    NSString *regiUrl = [NSString stringWithFormat:@"%@%@",baseUrl,str];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0&&[YQObjectBool boolForObject:response.data]) {
            self.invoArr = [DetailTypeInfo objectArrayWithKeyValuesArray:response.data[@"invoiceType"]];
            [self.tableFView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@(40+self.invoArr.count*40));
            }];
            if (self.invoInfo) {
                [self setupWithStr:self.invoInfo.title];
            }
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:response.message];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (void)setupWithStr:(NSString *)index{
    if (self.invoArr.count==0) {
        return;
    }
    for (DetailTypeInfo *typeInfo in self.invoArr) {
        if ([typeInfo.title isEqualToString:index]) {
            typeInfo.isSel = YES;
        }
    }
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.invoArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseInvoiceCell *invoCell = [ChooseInvoiceCell cellWithTableView:tableView];
    DetailTypeInfo *typeInfo = self.invoArr[indexPath.row];
    invoCell.deInfo = typeInfo;
    return invoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailTypeInfo *typeInfo = self.invoArr[indexPath.row];
    [self setupArr:typeInfo.id];
}

- (void)setupArr:(int)index{
    if (self.invoArr.count==0) {
        return;
    }
    for (DetailTypeInfo *typeInfo in self.invoArr) {
        typeInfo.isSel = NO;
        if (typeInfo.id==index) {
            typeInfo.isSel = YES;
        }
    }
    [self.tableView reloadData];
}

- (IBAction)confirmClick:(id)sender {
    if (self.nameFie.text.length==0) {
        [MBProgressHUD showError:@"请填写发票抬头"];
        return;
    }
    DetailTypeInfo *typeChInfo = [DetailTypeInfo new];
    for (DetailTypeInfo *typeInfo in self.invoArr) {
        if (typeInfo.isSel) {
            typeChInfo = typeInfo;
        }
    }
    if (!typeChInfo.id) {
        [MBProgressHUD showError:@"请选择发票内容"];
        return;
    }
    typeChInfo.price = self.nameFie.text;
    [self goBackConfirmOrder:typeChInfo];
}

- (IBAction)cancelClick:(id)sender {
    DetailTypeInfo *typeInfo = [DetailTypeInfo new];
    typeInfo.title = @"";
    [self goBackConfirmOrder:typeInfo];
}

- (void)goBackConfirmOrder:(DetailTypeInfo *)typeInfo{
    if (self.invoBack) {
        self.invoBack(typeInfo);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
