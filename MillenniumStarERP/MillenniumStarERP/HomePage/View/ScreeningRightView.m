//
//  ScreeningRightView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/20.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ScreeningRightView.h"
#import "CDRTranslucentSideBar.h"
#import "PopViewMultipleCell.h"
#import "ScreeningInfo.h"
#import "ScreeningTableCell.h"
#import "ScreeningHeadSView.h"
#import "StrWithIntTool.h"
#import "ScreenDetailInfo.h"
#import "ScreeningTopView.h"
@interface ScreeningRightView()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_sildeTableView;
    NSMutableArray *_imgBtns;
}
@property (nonatomic, weak)ScreeningTopView *topView;
@end
@implementation ScreeningRightView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBaseView:frame];
    }
    return self;
}

- (void)setBaseView:(CGRect)frame{
    ScreeningTopView *topV = [[ScreeningTopView alloc]init];
    topV.back = ^(NSArray *arr){
        self.goods = arr;
    };
    [self addSubview:topV];
    [topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(@0);
    }];
    self.topView = topV;
    
    _imgBtns = [NSMutableArray new];
    _sildeTableView = [[UITableView alloc]initWithFrame:CGRectZero
                                            style:UITableViewStyleGrouped];
    _sildeTableView.backgroundColor = [UIColor whiteColor];
    _sildeTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    _sildeTableView.delegate = self;
    _sildeTableView.dataSource = self;
    _sildeTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _dictB = @{}.mutableCopy;
    [self addSubview:_sildeTableView];
    [_sildeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).with.offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(-40);
    }];
    self.backgroundColor = [UIColor whiteColor];
    UIButton *sureBtn = [self setB:@"确定" andS:88 andC:MAIN_COLOR];
    UIButton *cancelBtn = [self setB:@"重置筛选" andS:89 andC:[UIColor lightGrayColor]];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.height.mas_equalTo(@40);
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
//底部按钮
- (void)bottomBtnClick:(UIButton *)btn{
    if (btn.tag==88) {
        [self btnClick];
    }else{
        [self cancelClick];
    }
}

- (void)btnClick{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.goods.count>0) {
        for (ScreeningInfo *info in self.goods) {
            params[info.groupKey] = @[].mutableCopy;
        }
        for (ScreeningInfo *info in self.goods) {
            NSMutableArray *mutA = params[info.groupKey];
            for (ScreenDetailInfo *dInfo in info.attributeList) {
                if (dInfo.isSelect) {
                    [mutA addObject:dInfo.value];
                }
            }
        }
    }
    if (params.count>0) {
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj count]>0) {
                params[key] = [StrWithIntTool strWithArr:obj];
            }else{
                [params removeObjectForKey:key];
            }
        }];
    }
    [_dictB addEntriesFromDictionary:params];
    if (self.values.count>0) {
        for (WeightInfo *info in self.values) {
            _dictB[info.name] = info.value;
        }
    }
    if (self.tableBack) {
        self.tableBack(_dictB,params.count);
    }
    if (self.rightSideBar) {
        [self.rightSideBar dismiss];
    }
}

- (void)cancelClick{
    if (self.goods.count>0) {
        for (ScreeningInfo *info in self.goods) {
            for (ScreenDetailInfo *dInfo in info.attributeList) {
                dInfo.isSelect = NO;
            }
        }
    }
    if (self.values.count>0) {
        for (WeightInfo *info in self.values) {
            info.value = @"";
            info.txt = @"";
        }
    }
    [self setGoods:_goods];
}

- (void)setGoods:(NSArray *)goods{
    if (goods.count>0) {
        _goods = goods;
        if (_isTop) {
            NSMutableArray *mutA = [NSMutableArray array];
            for (ScreeningInfo *info in _goods) {
                for (ScreenDetailInfo *dInfo in info.attributeList) {
                    if (dInfo.isSelect&&info.mulSelect) {
                        [mutA addObject:info];
                    }
                }
            }
            for (WeightInfo *wInfo in self.values) {
                if (wInfo.txt.length>0) {
                    [mutA addObject:wInfo];
                }
            }
            CGFloat height = 20+ROWSPACE;
            int row = 0;
            if (mutA.count>0) {
                row = (int)(mutA.count-1)/HCOLUMN+1;
            }
            CGFloat topH = height+(HROWHEIHT+HROWSPACE)*row;
            _topView.values = _values;
            _topView.goods = _goods;
            [_topView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(topH);
            }];
        }
        [_dictB removeAllObjects];
        [_sildeTableView reloadData];
    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.goods.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScreeningInfo * sInfo = self.goods[indexPath.section];
    NSInteger total = sInfo.attributeList.count;
    NSInteger rows = (total / COLUMN) + ((total % COLUMN) > 0 ? 1 : 0);
    if (!sInfo.mulSelect) {
        rows = rows+1;
    }
    CGFloat height = (float)ROWHEIHT * rows + ROWSPACE * (rows + 1);
    return sInfo.isOpen?0:height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ScreeningInfo * sInfo = self.goods[section];
    ScreeningHeadSView *headView = [[ScreeningHeadSView alloc]initWithFrame:
        CGRectMake(0, 0, SDevWidth*0.8, 40) WithIdx:section andTitle:sInfo.title];
    headView.didScreenWithIndex = ^(NSInteger index){
        ScreeningInfo *info = self.goods[index];
        info.isOpen = !info.isOpen;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        [_sildeTableView reloadRowsAtIndexPaths:@[indexPath]
                               withRowAnimation:UITableViewRowAnimationNone];
    };
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScreeningInfo *info = self.goods[indexPath.section];
    ScreeningTableCell *mulCell = [ScreeningTableCell cellWithTableView:tableView];
    if (!info.mulSelect) {
        for (WeightInfo *wInfo in self.values) {
            if ([wInfo.name isEqualToString:info.groupKey]) {
                mulCell.wInfo = wInfo;
            }
        }
    }
    mulCell.info = info;
    return mulCell;
}

@end
