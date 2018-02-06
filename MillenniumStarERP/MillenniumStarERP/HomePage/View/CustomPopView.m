//
//  CustomPopView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/10/9.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "CustomPopView.h"
#import "DetailTypeInfo.h"
@interface CustomPopView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *types;
@property (nonatomic,  weak)UILabel *tLab;
@end
@implementation CustomPopView

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
            make.center.mas_equalTo(self);
            make.height.mas_equalTo(self.mas_height).multipliedBy(0.5);
            make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
        }];
        
        UILabel *title = [[UILabel alloc]init];
        title.font = [UIFont systemFontOfSize:18];
        title.backgroundColor = DefaultColor;
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"请选择成色";
        [self addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.equalTo(self.tableView.mas_top).with.offset(0);
            make.height.mas_equalTo(@44);
            make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
        }];
        self.tLab = title;
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cancel.backgroundColor = DefaultColor;
        [self addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.equalTo(self.tableView.mas_bottom).offset(0);
            make.height.mas_equalTo(@44);
            make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
        }];
    }
    return self;
}

- (void)reFreshTable{
    [self.tableView reloadData];
}

- (void)setTypeList:(NSArray *)typeList{
    if (typeList.count>0) {
        _typeList = typeList;
        if (_titleStr.length>0) {
            self.tLab.text = _titleStr;
        }
        self.types = [DetailTypeInfo mj_objectArrayWithKeyValuesArray:_typeList];
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
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
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
    if (self.section) {
        mud[self.section] = info;
    }else{
        mud[@"mess"] = info;
    }
    if (self.popBack) {
        self.popBack(mud);
    }
}

@end
