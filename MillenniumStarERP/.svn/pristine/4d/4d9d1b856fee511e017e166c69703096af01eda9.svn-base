//
//  AddressTableVC.m
//  MillenniumStar
//
//  Created by yjq on 15/7/27.
//  Copyright (c) 2015年 Millennium Star. All rights reserved.
//

#import "AddressTableVC.h"
#import "Citys.h"
#import "SubCityTableVc.h"
@interface AddressTableVC ()
@property (nonatomic,retain)NSArray *citys;
@end

@implementation AddressTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择地址";
    [self loadRequest];
}

- (void)loadRequest{
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@userAddAddressPage",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            self.citys = [Citys objectArrayWithKeyValuesArray:response.data[@"provinceList"]];
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.citys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Id = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Id];
    }
    Citys *city = self.citys[indexPath.row];
    cell.textLabel.text = city.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SubCityTableVc *subvc = [[SubCityTableVc alloc]initWithStyle:UITableViewStyleGrouped];
    subvc.city = self.citys[indexPath.row];
    subvc.provinceID = (int)indexPath.row+1;
    [self.navigationController pushViewController:subvc animated:YES];
}

@end
