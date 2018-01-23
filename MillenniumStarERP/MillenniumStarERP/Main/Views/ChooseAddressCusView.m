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
@property (nonatomic, copy) NSDictionary * dic;
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
        [self setLayerWithW:3 andColor:BordColor andBackW:0.0001];
        self.tableView.tableFooterView = [UIView new];
        self.tableView.bounces = NO;
        [self loadHomeData];
    }
    return self;
}

- (void)loadHomeData{
    self.list = @[];
    self.dic = @{};
    NSString *url = [NSString stringWithFormat:@"%@userRegisterPage",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0&&[YQObjectBool boolForObject:response.data[@"memberArealist"]]) {
            self.list = response.data[@"memberArealist"];
            [self.tableView reloadData];
        }
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
    cell.textLabel.text = dic[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *chooseD;
    if (indexPath.row<self.list.count) {
        chooseD = self.list[indexPath.row];
    }
    self.dic = chooseD;
}

- (IBAction)cancelClick:(id)sender {
    if (self.storeBack&&self.dic) {
        self.storeBack(self.dic,YES);
    }
}

@end
