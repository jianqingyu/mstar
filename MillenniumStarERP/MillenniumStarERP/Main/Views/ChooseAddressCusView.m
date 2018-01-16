//
//  ChooseAddressCusView.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/1/16.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "ChooseAddressCusView.h"
@interface ChooseAddressCusView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *list;
@end
@implementation ChooseAddressCusView

+ (ChooseAddressCusView *)createLoginView{
    static ChooseAddressCusView *_InfoView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _InfoView = [[ChooseAddressCusView alloc]init];
    });
    return _InfoView;
}

- (id)init{
    self = [super init];
    if (self) {
        NSString *cell = @"ChooseAddressCusView";
        self = [[NSBundle mainBundle]loadNibNamed:cell owner:nil options:nil][0];
        self.tableView.tableFooterView = [UIView new];
        self.tableView.bounces = NO;
    }
    return self;
}

- (void)loadHomeData{
    NSString *url = [NSString stringWithFormat:@"%@api/shop/all",baseNet];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        [self.tableView reloadData];
    } requestURL:url params:params];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Id = @"customCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = CUSTOM_COLOR(40, 40, 40);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    NSDictionary *dic;
    if (indexPath.row<self.list.count) {
        dic = self.list[indexPath.row];
    }
    cell.textLabel.text = dic[@"shopName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic;
    if (indexPath.row<self.list.count) {
        dic = self.list[indexPath.row];
    }
    if (self.storeBack) {
        self.storeBack(dic,YES);
    }
}

- (IBAction)cancelClick:(id)sender {
    if (self.storeBack) {
        self.storeBack(@{},NO);
    }
}

@end
