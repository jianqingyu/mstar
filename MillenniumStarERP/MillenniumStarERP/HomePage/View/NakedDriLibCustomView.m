//
//  NakedDriLibCustomView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/7/25.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriLibCustomView.h"
#import "NakedDriListOrderVc.h"
#import "NakedDriLibHeadView.h"
#import "NakedDriLibListCell.h"
#import "NakedDriLibBLabCell.h"
#import "NakedDriLibSLabCell.h"
#import "NakedDriLiblistInfo.h"
#import "NakedDriLibInfo.h"
#import "NakedDriLibImgInfo.h"
#import "StrWithIntTool.h"
#import "NakedDriSearchVC.h"
#import "NetworkDetermineTool.h"
@interface NakedDriLibCustomView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSArray *headArr;
@property (nonatomic, strong)NSDictionary *dict;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *NakedArr;
@property (nonatomic, strong)NakedDriLiblistInfo *hedInfo;
@property (nonatomic,   weak)NakedDriLibHeadView *headView;
@end
@implementation NakedDriLibCustomView

+ (NakedDriLibCustomView *)creatCustomView{
    NakedDriLibCustomView *nakedView = [[NakedDriLibCustomView alloc]init];
    return nakedView;
}

- (id)init{
    self = [super init];
    if (self) {
        [self creatBaseView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.tableView reloadData];
}

- (void)creatBaseView{
    [self setNakedTableView];
    [self setNakedHeadView];
    [self setHomeData];
    self.NakedArr = @[].mutableCopy;
    // 9.0以上才有这个属性，针对ipad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0){
        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
}

- (void)setSeaDic:(NSDictionary *)seaDic{
    if (seaDic) {
        _seaDic = seaDic;
        if (self.headArr.count>0) {
            _headView.seaDic = _seaDic;
        };
    }
}

- (void)setNakedTableView{
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
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    UIButton *sureBtn = [self setB:@"查询" andS:88 andC:MAIN_COLOR];
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

- (void)setNakedHeadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 250)];
    headView.backgroundColor = DefaultColor;
    NakedDriLibHeadView *headV = [[NakedDriLibHeadView alloc]initWithFrame:
                                  CGRectMake(0, 0, SDevWidth, 250)];
    headV.back = ^(id mess){
        self.dict = mess;
    };
    [headView addSubview:headV];
    self.tableView.tableHeaderView = headView;
    self.headView = headV;
}

- (void)setHomeData{
    NSString *regiUrl = [NSString stringWithFormat:@"%@stoneSearchInfoInhk",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"certAuth"]]) {
                _hedInfo = [NakedDriLiblistInfo objectWithKeyValues:response.data[@"certAuth"]];
                self.headView.info = [self lisInfoWith:_hedInfo];
            }
            NSMutableArray *mutH = [NSMutableArray new];
            if ([YQObjectBool boolForObject:response.data[@"weight"]]) {
                [mutH addObject:response.data[@"weight"]];
            }
            if ([YQObjectBool boolForObject:response.data[@"price"]]) {
                [mutH addObject:response.data[@"price"]];
            }
            self.headView.topArr = mutH.copy;
            self.headArr = mutH.copy;
            if (self.seaDic) {
                self.headView.seaDic = self.seaDic;
            }
            NSMutableArray *mut = [NSMutableArray new];
            if ([YQObjectBool boolForObject:response.data[@"shape"]]) {
                NakedDriLiblistInfo *info = [NakedDriLiblistInfo objectWithKeyValues:response.data[@"shape"]];
                [mut addObject:[self ImgInfoWith:info]];
            }
            NSMutableArray *mutA = [NSMutableArray new];
            if ([YQObjectBool boolForObject:response.data[@"color"]]) {
                NakedDriLiblistInfo *info = [NakedDriLiblistInfo objectWithKeyValues:response.data[@"color"]];
                [mutA addObject:[self lisInfoWith:info]];
            }
            if ([YQObjectBool boolForObject:response.data[@"purity"]]) {
                NakedDriLiblistInfo *info = [NakedDriLiblistInfo objectWithKeyValues:response.data[@"purity"]];
                [mutA addObject:[self lisInfoWith:info]];
            }
            NSMutableArray *mutB = [NSMutableArray new];
            if ([YQObjectBool boolForObject:response.data[@"cut"]]) {
                NakedDriLiblistInfo *info = [NakedDriLiblistInfo objectWithKeyValues:response.data[@"cut"]];
                [mutB addObject:[self lisInfoWith:info]];
            }
            if ([YQObjectBool boolForObject:response.data[@"polishing"]]) {
                NakedDriLiblistInfo *info = [NakedDriLiblistInfo objectWithKeyValues:response.data[@"polishing"]];
                [mutB addObject:[self lisInfoWith:info]];
            }
            if ([YQObjectBool boolForObject:response.data[@"symmetric"]]) {
                NakedDriLiblistInfo *info = [NakedDriLiblistInfo objectWithKeyValues:response.data[@"symmetric"]];
                [mutB addObject:[self lisInfoWith:info]];
            }
            if ([YQObjectBool boolForObject:response.data[@"fluorescence"]]) {
                NakedDriLiblistInfo *info = [NakedDriLiblistInfo objectWithKeyValues:response.data[@"fluorescence"]];
                [mutB addObject:[self lisInfoWith:info]];
            }
            if (mut.count>0) {
                [self.NakedArr addObject:mut];
            }
            if (mutA.count>0) {
                [self.NakedArr addObject:mutA];
            }
            if (mutB.count>0) {
                [self.NakedArr addObject:mutB];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else{
            [MBProgressHUD showError:response.message];
        }
    } requestURL:regiUrl params:params];
}

- (NakedDriLiblistInfo *)ImgInfoWith:(NakedDriLiblistInfo *)info{
    NSMutableArray *arr = [NSMutableArray new];
    for (NSDictionary *dic in info.values) {
        NakedDriLibImgInfo *linfo = [NakedDriLibImgInfo new];
        linfo.pic = dic[@"pic"];
        linfo.pic1 = dic[@"pic1"];
        linfo.name = dic[@"name"];
        [arr addObject:linfo];
    }
    info.values = arr.copy;
    return info;
}

- (NakedDriLiblistInfo *)lisInfoWith:(NakedDriLiblistInfo *)info{
    NSMutableArray *arr = [NSMutableArray new];
    for (NSString *str in info.values) {
        NakedDriLibInfo *linfo = [NakedDriLibInfo new];
        linfo.name = str;
        [arr addObject:linfo];
    }
    info.values = arr.copy;
    return info;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.NakedArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.NakedArr[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = self.NakedArr[indexPath.section];
    if (indexPath.section==0) {
        NakedDriLibListCell *imgCell = [NakedDriLibListCell cellWithTableView:tableView];
        imgCell.imgInfo = arr[indexPath.row];
        return imgCell;
    }else if (indexPath.section==1){
        NakedDriLibBLabCell *BCell = [NakedDriLibBLabCell cellWithTableView:tableView];
        BCell.textInfo = arr[indexPath.row];
        return BCell;
    }else{
        NakedDriLibSLabCell *sCell = [NakedDriLibSLabCell cellWithTableView:tableView];
        sCell.textSInfo = arr[indexPath.row];
        return sCell;
    }
}

- (void)searchClick:(id)sender {
    if (![NetworkDetermineTool isExistenceNet]) {
        [MBProgressHUD showError:@"网络断开、请联网"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *mutA = @[].mutableCopy;
    if (_hedInfo.values.count>0) {
        for (id info in _hedInfo.values) {
            BOOL isSel = [[info valueForKey:@"isSel"]boolValue];
            NSString *name = [info valueForKey:@"name"];
            if (isSel) {
                [mutA addObject:name];
            }
        }
        params[_hedInfo.keyword] = mutA.copy;
    }
    if (self.NakedArr.count>0) {
        for (NSArray *arr in self.NakedArr) {
            for (NakedDriLiblistInfo *linfo in arr) {
                NSMutableArray *mutA = @[].mutableCopy;
                for (id info in linfo.values) {
                    BOOL isSel = [[info valueForKey:@"isSel"]boolValue];
                    NSString *name = [info valueForKey:@"name"];
                    if (isSel) {
                        [mutA addObject:name];
                    }
                }
                params[linfo.keyword] = mutA.copy;
            }
        }
    }
    if (params.count>0) {
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj count]>0) {
                params[key] = [StrWithIntTool strWithArr:obj With:@","];
            }else{
                [params removeObjectForKey:key];
            }
        }];
    }
    [params addEntriesFromDictionary:self.dict];
    NakedDriSearchVC *seaVc = [NakedDriSearchVC new];
    seaVc.isPro = self.isPro;
    seaVc.isCus = self.isCus;
    seaVc.isSel = self.isSel;
    seaVc.seaDic = params;
    [self.supNav pushViewController:seaVc animated:YES];
}

- (void)resetClick:(id)sender {
    for (id info in _hedInfo.values) {
        [info setValue:@NO forKey:@"isSel"];
    }
    for (NSArray *arr in self.NakedArr) {
        for (NakedDriLiblistInfo *linfo in arr) {
            for (id info in linfo.values) {
                [info setValue:@NO forKey:@"isSel"];
            }
        }
    }
    [self.headView setAllNoChoose];
    self.dict = @{};
    [self.tableView reloadData];
}

@end
