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
            make.height.mas_equalTo(@(_typeList.count*44));
            make.width.mas_equalTo(@(SDevWidth*0.5));
        }];
        
        UILabel *title = [[UILabel alloc]init];
        title.font = [UIFont systemFontOfSize:18];
        title.backgroundColor = DefaultColor;
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"请选择类型";
        [self addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.equalTo(self.tableView.mas_top).with.offset(0);
            make.height.mas_equalTo(@44);
            make.width.mas_equalTo(@(SDevWidth*0.5));
        }];
        
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
            make.width.mas_equalTo(@(SDevWidth*0.5));
        }];
    }
    return self;
}

- (void)setTypeList:(NSArray *)typeList{
    if (typeList.count>0) {
        _typeList = typeList;
        CGFloat height = MIN(5*44, _typeList.count*44);
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cusCell"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    DetailTypeInfo *info = self.types[indexPath.row];
    cell.textLabel.text = info.title;
    if (info.price.length>0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@/g",info.price];
    }else{
        cell.detailTextLabel.text = @"";
    }
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
