//
//  DistrictTableVc.m
//  MillenniumStar
//
//  Created by yjq on 15/7/28.
//  Copyright (c) 2015年 Millennium Star. All rights reserved.
//

#import "DistrictTableVc.h"
@interface DistrictTableVc ()
@property (nonatomic,retain)NSArray *Districts;
@end

@implementation DistrictTableVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
     [SVProgressHUD show];
    [self loadRequest];
}

- (void)loadRequest{

    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@getArea",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"id"] = @(self.subCity.id);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            self.Districts = [Citys objectArrayWithKeyValuesArray:response.data];
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
        return self.Districts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@",self.city,self.subCity.name];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        return cell;
    }else{
        static NSString *ID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        Citys *areaCity = self.Districts[indexPath.row];
        cell.textLabel.text = areaCity.name;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        [self backToNewAddVc:indexPath.row];
    }
}

- (void)backToNewAddVc:(NSUInteger)row{
    Citys *areaCity = self.Districts[row];
    NSString *userStr = [NSString stringWithFormat:@"%@%@%@",self.city,self.subCity.name,areaCity.name];
    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:userStr,[NSString stringWithFormat:@"%d",self.proID],[NSString stringWithFormat:@"%d",self.subCity.id],[NSString stringWithFormat:@"%d",areaCity.id],nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationName object:nil userInfo:@{UserInfoName:array}];
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    NSInteger index = self.navigationController.viewControllers.count;
    [navigationArray removeObjectAtIndex: index-1];
    [navigationArray removeObjectAtIndex: index-2];
    [navigationArray removeObjectAtIndex: index-3];
    self.navigationController.viewControllers = navigationArray;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
