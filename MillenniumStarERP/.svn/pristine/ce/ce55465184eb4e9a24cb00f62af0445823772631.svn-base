//
//  RemarkPopView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/10/19.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "RemarkPopView.h"
@interface RemarkPopView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@end
@implementation RemarkPopView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
        self.tableView = [[UITableView alloc]init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self).offset(-74);
            make.height.mas_equalTo(@(_typeList.count*44));
            make.width.mas_equalTo(@(SDevWidth*0.4));
        }];
    }
    return self;
}

- (void)setTypeList:(NSArray *)typeList{
    if (typeList.count>0) {
        _typeList = typeList;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(_typeList.count*44));
        }];
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _typeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cusCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cusCell"];
    }
    NSDictionary *info = self.typeList[indexPath.row];
    cell.textLabel.text = info[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *info = self.typeList[indexPath.row];
    if (self.popBack) {
        self.popBack(info[@"content"]);
    }
    [self removeFromSuperview];
}

@end
