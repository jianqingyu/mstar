//
//  BulkOrderViewController.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/3/27.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "BulkOrderViewController.h"
#import "BulkOrderInfo.h"
#import "ConfirmOrderVC.h"
#import "BulkOrderTableCell.h"
@interface BulkOrderViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIWebView *ExcelWebView;
@property (weak,  nonatomic) IBOutlet UITableView *tableView;
@property (weak,  nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic,strong) NSMutableArray *listArr;
@property (nonatomic,  copy) NSArray *errorArr;
@end

@implementation BulkOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"批量下单";
    [self setWebView];
    [self.sureBtn setLayerWithW:3 andColor:BordColor andBackW:0.001];
    if (self.isPre) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:
         [UIImage imageNamed:@"icon_return"] style:UIBarButtonItemStyleDone
             target:self action:@selector(backClick)];
    }
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)backClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setWebView{
    _ExcelWebView = [[UIWebView alloc]initWithFrame:CGRectZero];
    _ExcelWebView.delegate = self;
//    _ExcelWebView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
//    [_ExcelWebView setClipsToBounds:YES];//设置为界限
//    [_ExcelWebView setScalesPageToFit:YES];//页面设置为合适
    [self showExcelData:self.path];
    [self.view addSubview:_ExcelWebView];
}

- (void)showExcelData:(NSString *)ExcelName{
    NSURL *url = [NSURL fileURLWithPath:ExcelName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_ExcelWebView loadRequest:request];
}
//打印Excel数据
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *strings = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
    if (![strings containsString:@"\t"]) {
        UILabel *lab = [UILabel new];
        lab.text = @"导入的格式不对,有多个标签页(Sheet)";
        [self.view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
        }];
        return;
    }
    
    NSArray *array = [strings componentsSeparatedByString:@"\n"]; //从字符中分隔成2个元素的数组
    NSDictionary *dic = @{@"款号":@"modelNum",@"数量":@"number",@"成色":@"purity",@"手寸":@"handSize"};
    NSMutableArray *mutA = @[].mutableCopy;
    NSArray *arrF;
    for (int i=0; i<array.count; i++) {
        NSArray *arr = [array[i] componentsSeparatedByString:@"\t"];
        if (arr.count<3) {
            continue;
        }else{
            if (arrF.count==0) {
                arrF = arr;
            }else{
                NSMutableDictionary *mutDic = @{}.mutableCopy;
                for (int j=0; j<arr.count; j++) {
                    NSString *mes   = [arrF[j] stringByReplacingOccurrencesOfString:@" " withString:@""];
                    NSString *values = [arr[j] stringByReplacingOccurrencesOfString:@" " withString:@""];
                    NSString *arrKey = dic[mes];
                    if(arrKey.length>0&&values.length>0) {
                        mutDic[arrKey] = values;
                    }else{
                        continue;
                    }
                }
                if (mutDic.count>0) {
                    [mutA addObject:mutDic];
                }
            }
        }
    }
    [self listArrwith:mutA];
}

- (void)listArrwith:(NSMutableArray *)mutA{
    if (mutA.count==0) {
        UILabel *lab = [UILabel new];
        lab.text = @"导入的格式不对,请参照标准格式下单";
        [self.view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
        }];
        return;
    }
    self.listArr = [BulkOrderInfo mj_objectArrayWithKeyValuesArray:mutA].mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self setBottomNumber];
        [self.ExcelWebView removeFromSuperview];
        self.ExcelWebView = nil;
    });
}
#pragma mark -- tableviewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BulkOrderTableCell *cell = [BulkOrderTableCell cellWithTableView:tableView];
    BulkOrderInfo *orderInfo;
    if (self.listArr.count>indexPath.row) {
        orderInfo = self.listArr[indexPath.row];
    }
    cell.info = orderInfo;
    return cell;
}
//左滑可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.listArr removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        [self setBottomNumber];
    }
}
// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
//下单
- (IBAction)conmitClick:(UIButton *)sender {
    if (self.listArr.count==0) {
        return;
    }
    sender.enabled = NO;
    [SVProgressHUD show];
    for (int i=0; i<self.listArr.count; i++) {
        BulkOrderInfo *info = self.listArr[i];
        info.id = [NSString stringWithFormat:@"%d",i+1];
    }
    NSString *url = [NSString stringWithFormat:@"%@BathOrderInCurrentDo?tokenKey=%@",
                     baseUrl,[AccountTool account].tokenKey];
    NSArray *mutA = [BulkOrderInfo mj_keyValuesArrayWithObjectArray:self.listArr];
    NSArray *reversedArray = [[mutA reverseObjectEnumerator]allObjects];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:reversedArray options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    params[@"json"] = jsonString;
    [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0&&[YQObjectBool boolForObject:response.data]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                ConfirmOrderVC *orderVC = [ConfirmOrderVC new];
                [self.navigationController pushViewController:orderVC animated:YES];
            });
        }
        if ([YQObjectBool boolForObject:response.data[@"ErrData"]]) {
            for (NSDictionary *dic in response.data[@"ErrData"]) {
                int index = [dic[@"id"]intValue];
                if (index<self.listArr.count) {
                    BulkOrderInfo *info = self.listArr[index-1];
                    info.isErr = YES;
                    info.message = [NSString stringWithFormat:@"%@ %@",
                                    dic[@"modelNum"],dic[@"purity"]];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self setBottomNumber];
            });
        }
        [MBProgressHUD showError:response.message];
        sender.enabled = YES;
    } requestURL:url params:params];
}

- (void)setBottomNumber{
    NSString *str = [NSString stringWithFormat:@"批量下单(%d)",(int)self.listArr.count];
    [self.sureBtn setTitle:str forState:UIControlStateNormal];
}

@end
