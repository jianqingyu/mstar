//
//  SubCityTableVc.m
//  MillenniumStar
//
//  Created by yjq on 15/7/27.
//  Copyright (c) 2015年 Millennium Star. All rights reserved.
//

#import "SubCityTableVc.h"
#import "MJExtension.h"
#import "DistrictTableVc.h"
@interface SubCityTableVc ()
@property (nonatomic,retain)NSArray *subCitys;
@end

@implementation SubCityTableVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择地址";
    [self loadRequest];
}

- (void)loadRequest{
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@getCity",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"id"] = @(self.city.id);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0&&[YQObjectBool boolForObject:response.data]) {
            self.subCitys = [Citys objectArrayWithKeyValuesArray:response.data];
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else{
       return self.subCitys.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.textLabel.text = self.city.name;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        return cell;
    }else{
        static NSString *ID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        Citys *city = self.subCitys[indexPath.row];
        cell.textLabel.text = city.name;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        DistrictTableVc *disTablevc = [[DistrictTableVc alloc]initWithStyle:UITableViewStyleGrouped];
        disTablevc.city = self.city.name;
        disTablevc.proID = self.city.id;
        disTablevc.subCity = self.subCitys[indexPath.row];
        [self.navigationController pushViewController:disTablevc animated:YES];
    }
}

@end
