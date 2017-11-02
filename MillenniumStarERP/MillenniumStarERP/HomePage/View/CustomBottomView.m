//
//  CustomBottomView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/4/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "CustomBottomView.h"
#import "DetailTypeInfo.h"
@interface CustomBottomView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *types;
@end
@implementation CustomBottomView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *title = [[UILabel alloc]init];
        title.font = [UIFont systemFontOfSize:18];
        title.backgroundColor = DefaultColor;
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"请选择类型";
        [self addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(0);
            make.height.mas_equalTo(@44);
            make.width.mas_equalTo(@(SDevWidth*0.6));
        }];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cancel.backgroundColor = DefaultColor;
        [self addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(0);
            make.height.mas_equalTo(@44);
            make.width.mas_equalTo(@60);
        }];
        
        UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
        [sure setTitle:@"取消" forState:UIControlStateNormal];
        [sure setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sure addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        sure.backgroundColor = DefaultColor;
        [self addSubview:sure];
        [sure mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self).offset(0);
            make.height.mas_equalTo(@44);
            make.width.mas_equalTo(@60);
        }];
        
        self.tableView = [[UITableView alloc]init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sure.mas_bottom).offset(0);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(SDevHeight *0.3);
            make.width.mas_equalTo(SDevWidth);
        }];
    }
    return self;
}

- (void)setTypeList:(NSArray *)typeList{
    if (typeList.count>0) {
        _typeList = typeList;
        CGFloat height = MIN(SDevHeight *0.3, _typeList.count*44);
        self.types = [DetailTypeInfo objectArrayWithKeyValuesArray:_typeList];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(height));
        }];
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.types.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cusCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cusCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    DetailTypeInfo *info = self.types[indexPath.row];
    cell.textLabel.text = info.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DetailTypeInfo *info = self.types[indexPath.row];
    [self backWithInfo:info];
}

- (void)cancelBtnClick:(id)sender{
    DetailTypeInfo *info = [DetailTypeInfo new];
    [self backWithInfo:info];
}

- (void)backWithInfo:(DetailTypeInfo *)info{
    NSMutableDictionary *mud = @{}.mutableCopy;
    mud[self.section] = info;
    if (self.popBack) {
        self.popBack(mud);
    }
    [self removeFromSuperview];
}

@end
