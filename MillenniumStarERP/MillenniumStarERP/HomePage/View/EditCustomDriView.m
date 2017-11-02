//
//  EditCustomDriView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/7/21.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "EditCustomDriView.h"
#import "EditCustomImgDriLibCell.h"
#import "EditCustomDriLibCell.h"
#import "StrWithIntTool.h"
#import "DetailTypeInfo.h"
#import "EditCustomDriTableCell.h"
@interface EditCustomDriView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)BOOL isSel;
@property (nonatomic,   copy)NSArray *arr;
@property (nonatomic,   copy)NSString *weight;
@property (nonatomic, strong)NSDictionary *dict;
@property (nonatomic,   weak)EditCustomDriTableCell *fieCell;
@end
@implementation EditCustomDriView

+ (EditCustomDriView *)creatCustomView{
    EditCustomDriView *editView = [[EditCustomDriView alloc]init];
    return editView;
}

- (id)init{
    self = [super init];
    if (self) {
        [self setNakedTableView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.tableView reloadData];
}

- (void)setInfoArr:(NSArray *)infoArr{
    if (infoArr) {
        _infoArr = infoArr;
        for (int i=0; i<_infoArr.count; i++) {
            DetailTypeInfo *info = _infoArr[i];
            if (info.title.length==0) {
                continue;
            }
            if (i==1) {
                self.weight = info.title;
            }
            for (DetailTypeInfo *dinfo in _NakedArr[i]) {
                if (dinfo.id==info.id) {
                    dinfo.isSel = YES;
                }
            }
        }
    }
}

- (void)setNakedTableView{
    self.arr = @[@"类型",@"数量",@"形状",@"颜色",@"净度"];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(-50);
    }];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    // 9.0以上才有这个属性，针对ipad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0){
        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    UIButton *sureBtn = [self setB:@"确定" andS:88 andC:MAIN_COLOR];
    UIButton *cancelBtn = [self setB:@"重置" andS:89 andC:[UIColor lightGrayColor]];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.height.mas_equalTo(@50);
        make.bottom.equalTo(self).offset(0);
        make.width.equalTo(cancelBtn);
        make.right.equalTo(cancelBtn.mas_left).with.offset(0);
    }];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sureBtn.mas_right).offset(0);
        make.height.equalTo(sureBtn);
        make.bottom.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.width.equalTo(sureBtn);
    }];
}

- (UIButton *)setB:(NSString *)title andS:(int)tag andC:(UIColor *)color{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
    [btn addTarget:self action:@selector(bottomBtnClick:)
                                  forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

- (void)bottomBtnClick:(UIButton *)btn{
    if (btn.tag==88) {
        [self searchClick:btn];
    }else{
        [self resetClick:btn];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.NakedArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, SDevWidth, 30);
        btn.selected = self.isSel;
        btn.backgroundColor = BarColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:@"展开全部" forState:UIControlStateNormal];
        [btn setTitle:@"隐藏" forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        return btn;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 30;
    }
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = self.NakedArr[indexPath.section];
    if (indexPath.section==0) {
        EditCustomDriLibCell *BCell = [EditCustomDriLibCell cellWithTableView:tableView];
        BCell.isSmall = !self.isSel;
        BCell.titleStr = self.arr[indexPath.section];
        BCell.libArr = arr;
        return BCell;
    }else if (indexPath.section==1){
        EditCustomDriTableCell *driCell = [EditCustomDriTableCell cellWithTableView:tableView];
        driCell.weight = self.weight;
        driCell.number = self.number;
        driCell.fieBack = ^(NSArray *arr){
            self.weight = arr[0];
            self.number = arr[1];
        };
        return driCell;
    }else if (indexPath.section==2){
        EditCustomImgDriLibCell *imgCell = [EditCustomImgDriLibCell cellWithTableView:tableView];
        imgCell.titleStr = self.arr[indexPath.section];
        imgCell.libArr = arr;
        return imgCell;
    }else{
        EditCustomDriLibCell *BCell = [EditCustomDriLibCell cellWithTableView:tableView];
        BCell.titleStr = self.arr[indexPath.section];
        BCell.libArr = arr;
        return BCell;
    }
}

- (void)btnClick:(UIButton *)btn{
    self.isSel = !self.isSel;
    [self.tableView reloadData];
}

- (void)searchClick:(id)sender {
    NSMutableArray *mutA = @[].mutableCopy;
    for (NSArray *arr in self.NakedArr) {
        int isEm = 0;
        for (DetailTypeInfo *info in arr) {
            if (info.isSel) {
                isEm = 1;
                [mutA addObject:info];
            }
        }
        if (!isEm) {
            [mutA addObject:[DetailTypeInfo new]];
        }
    }
    DetailTypeInfo *dInfo = [DetailTypeInfo new];
    dInfo.title = self.weight;
    [mutA setObject:dInfo atIndexedSubscript:1];
    if (self.editBack) {
        self.editBack(@{self.number:mutA});
    }
    [self.supNav popViewControllerAnimated:YES];
}

- (void)resetClick:(id)sender {
    for (NSArray *arr in self.NakedArr) {
        for (DetailTypeInfo *info in arr) {
            info.isSel = NO;
        }
    }
    self.number = @"";
    self.weight = @"";
    [self.tableView reloadData];
}

@end
