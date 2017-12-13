//
//  ClassListController.m
//  MillenniumStarERP
//
//  Created by yjq on 16/10/19.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ClassListController.h"
#import "ScreeningRightView.h"
#import "ScreenDetailInfo.h"
#import "ScreeningInfo.h"
#import "ProductListVC.h"
@interface ClassListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *typeList;
@property (nonatomic,  copy)NSArray *classList;
@property (nonatomic,strong)NSMutableDictionary *mutDict;
@property (nonatomic,strong)ScreeningRightView *slideRightTab;
@end

@implementation ClassListController
//初始化分类数据总是未选中
- (NSArray *)classList{
    if (_classList.count>0) {
        for (ScreeningInfo *info in _classList) {
            for (ScreenDetailInfo *dInfo in info.attributeList) {
                dInfo.isSelect = NO;
            }
        }
    }
    return _classList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类";
    self.mutDict = @{}.mutableCopy;
    [self setupBaseView];
    [self setupDetailData];
}

- (void)setupBaseView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = DefaultColor;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        make.width.mas_equalTo(@(MIN(SDevWidth, SDevHeight) *0.2));
    }];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.slideRightTab = [[ScreeningRightView alloc]initWithFrame:CGRectZero];
    self.slideRightTab.values = self.values;
    __weak typeof(self) weakSelf = self;
    self.slideRightTab.tableBack = ^(NSDictionary *dict,BOOL isSel){
        NSMutableDictionary *mutD = dict.mutableCopy;
        if (isSel) {
            NSArray *keys = [dict allKeys];
            BOOL isDic = [weakSelf boolWithArr:keys andMutDic:mutD andDic:dict];
            if (!isDic) {
                [mutD addEntriesFromDictionary:weakSelf.mutDict];
            }
        }else{
            [mutD addEntriesFromDictionary:weakSelf.mutDict];
        }
        NSInteger index = weakSelf.navigationController.viewControllers.count;
        ProductListVC * listVc = weakSelf.navigationController.viewControllers[index-2];
        listVc.backDict = mutD;
        if (weakSelf.listBack) {
            weakSelf.listBack(YES);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:self.slideRightTab];
    [self.slideRightTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        make.left.equalTo(self.tableView.mas_right).with.offset(0);
    }];
}

- (BOOL)boolWithArr:(NSArray *)arr andMutDic:(NSMutableDictionary *)mutDic andDic:(NSDictionary *)dict{
    for (NSString *str in arr) {
        if ([str isEqualToString:[self.mutDict allKeys][0]]) {
            mutDic [str] = [NSString stringWithFormat:@"%@|%@",self.mutDict[str],dict[str]];
            return YES;
        }
    }
    return NO;
}

- (void)setupDetailData{
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@modelFilerPage",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"typeList"]]) {
                self.typeList = [ScreenDetailInfo objectArrayWithKeyValuesArray:
                                                    response.data[@"typeList"]];
                ScreenDetailInfo *info = self.typeList[0];
                self.mutDict[info.groupKey] = info.value;
                
                [self.tableView reloadData];
                NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView selectRowAtIndexPath:first animated:YES
                                    scrollPosition:UITableViewScrollPositionTop];
            }
            if ([YQObjectBool boolForObject:response.data[@"typeFiler"]]) {
                NSArray *arr = [ScreeningInfo objectArrayWithKeyValuesArray:
                                      response.data[@"typeFiler"]];
                self.classList = arr;
                self.slideRightTab.goods = self.classList;
            }
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.typeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *Id = @"classCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.textLabel.numberOfLines = 2;
        cell.backgroundColor = DefaultColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    ScreenDetailInfo *info = self.typeList[indexPath.row];
    cell.textLabel.text = info.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ScreenDetailInfo *info = self.typeList[indexPath.row];
    [self.mutDict removeAllObjects];
    self.slideRightTab.goods = self.classList;
    self.mutDict[info.groupKey] = info.value;
}

@end
