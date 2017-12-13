//
//  NewCustomizationVC.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2017/12/7.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NewCustomizationVC.h"
#import "NewCustomizationView.h"
#import "HYBLoopScrollView.h"
#import "NewCustomizationInfo.h"
#import "StrWithIntTool.h"
#import "NewCustomizationHeadInfo.h"
@interface NewCustomizationVC ()
@property (nonatomic,assign)int height;
@property (nonatomic,assign)int cHeight;
@property (nonatomic,assign)int cWidth;
@property (nonatomic,assign)int index;
@property (nonatomic,strong)NSMutableArray *searchPids;
@property (nonatomic,strong)NSMutableArray *chooseArr;
@property (nonatomic,strong)NewCustomizationHeadInfo*headInfo;
@property (nonatomic,  copy)NSArray *headImg;
@property (nonatomic,  copy)NSArray *IDarray;
@property (nonatomic,  copy)NSArray *customArr;
@property (nonatomic,  copy)NSArray *puritys;
@property (nonatomic,  copy)NSArray *dataNum;
@property (nonatomic,  weak)NewCustomizationView *chooseV;
@property (nonatomic,  weak)NewCustomizationView *customV;
@property (nonatomic,  weak)HYBLoopScrollView *loopHead;
@end
@implementation NewCustomizationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Design of style";
    self.height = 1000;
    self.searchPids = @[].mutableCopy;
    self.chooseArr  = @[].mutableCopy;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [self loadHomeData];
}

- (void)orientChange:(NSNotification *)notification{
    [self changeTableHeadView];
    [self setupHeadView];
    [self creatBaseView];
}
#pragma mark -- 网络请求
- (void)loadHomeData{
    [SVProgressHUD show];
    NSString *detail = @"CreateCustomItem";
    NSString *netUrl = [NSString stringWithFormat:@"%@%@",baseUrl,detail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"modelItem"]]) {
                self.headInfo = [NewCustomizationHeadInfo mj_objectWithKeyValues:response.data[@"modelItem"]];
                [self creatCusTomHeadView:self.headInfo.modelPic];
                [self changeTableHeadView];
                [self setupHeadView];
                [self creatBaseView];
            }
            if ([YQObjectBool boolForObject:response.data[@"modelParts"]]) {
                NSArray *arr = [NewCustomizationInfo mj_objectArrayWithKeyValuesArray:response.data[@"modelParts"]];
                [self.chooseArr addObjectsFromArray:arr];
                self.chooseV.dataArr = self.chooseArr;
                for (int i=0; i<self.chooseArr.count; i++) {
                    [self.searchPids addObject:@""];
                }
            }
            if ([YQObjectBool boolForObject:response.data[@"modelpartCount"]]) {
                self.dataNum = response.data[@"modelpartCount"];
                self.chooseV.dataNum = self.dataNum;
            }
            if ([YQObjectBool boolForObject:response.data[@"modelPuritys"]]) {
                self.puritys = response.data[@"modelPuritys"];
            }
        }
    } requestURL:netUrl params:params];
}
//搜索部件
- (void)searchCusData{
    [SVProgressHUD show];
    NewCustomizationInfo *info = self.chooseArr[self.index];
    NSString *detail = @"CustomPartsList";
    NSString *netUrl = [NSString stringWithFormat:@"%@%@",baseUrl,detail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"partSort"] = info.partSort;
    params[@"selectPids"] = [StrWithIntTool strWithArr:self.searchPids With:@","];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"list"]]) {
                self.customArr = [NewCustomizationInfo mj_objectArrayWithKeyValuesArray:response.data[@"list"]];
                self.customV.dataArr = self.customArr;
            }
        }
    } requestURL:netUrl params:params];
}
#pragma mark - 初始化图片
- (void)creatCusTomHeadView:(NSArray *)picArr{
    NSMutableArray *pic  = @[].mutableCopy;
    NSMutableArray *mPic = @[].mutableCopy;
    NSMutableArray *bPic = @[].mutableCopy;
    for (NSDictionary*dict in picArr) {
        NSString *str = [self UsingEncoding:dict[@"pic"]];
        if (str.length>0) {
            [pic addObject:str];
        }
        NSString *strm = [self UsingEncoding:dict[@"picm"]];
        if (strm.length>0) {
            [mPic addObject:strm];
        }
        NSString *strb = [self UsingEncoding:dict[@"picb"]];
        if (strb.length>0) {
            [bPic addObject:strb];
        }
    }
    NSArray *headArr;
    if (mPic.count==0) {
        mPic = @[@"pic"].mutableCopy;
    }
    if (IsPhone) {
        headArr = mPic.copy;
    }else{
        headArr = bPic.copy;
    }
    self.headImg = headArr;
    self.IDarray = [bPic copy];
}

- (NSString *)UsingEncoding:(NSString *)str{
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
#pragma mark - 初始化头视图与滑动页面
- (void)changeTableHeadView{
    BOOL isVertical = SDevHeight>SDevWidth;
    if (isVertical) {
        self.cHeight = SDevWidth;
    }else{
        self.cWidth = SDevHeight-30;
        if (!IsPhone){
            self.cWidth = SDevHeight-50;
        }
    }
}

- (void)setupHeadView{
    BOOL isVertical = SDevHeight>SDevWidth;
    if (self.loopHead) {
        [self.loopHead removeFromSuperview];
        self.loopHead = nil;
    }
    CGRect headF = CGRectMake(0, 0, SDevWidth-self.cWidth, self.cWidth);
    if (!IsPhone){
        headF = CGRectMake(0, 20, SDevWidth-self.cWidth, self.cWidth);
    }
    if (isVertical) {
        headF = CGRectMake(0, 0, SDevWidth, SDevHeight-self.cHeight*0.8-68);
    }
    HYBLoopScrollView *loop = [HYBLoopScrollView loopScrollViewWithFrame:
                               headF imageUrls:self.headImg];
    loop.timeInterval = 6.0;
    loop.didSelectItemBlock = ^(NSInteger atIndex,HYBLoadImageView  *sender){
        //        [self imageTapGestureWithIndex:atIndex];
    };
    loop.alignment = kPageControlAlignRight;
    [self.view addSubview:loop];
    self.loopHead = loop;
}

- (void)creatBaseView{
    BOOL isVertical = SDevHeight>SDevWidth;
    if (self.chooseV) {
        [self.chooseV removeFromSuperview];
        self.chooseV = nil;
    }
    NewCustomizationView *cusV = [[NewCustomizationView alloc]initWithPop:YES];
    [self.view addSubview:cusV];
    cusV.isH = isVertical;
    cusV.back = ^(BOOL isDef, id model) {
        if (isDef) {
            if (![model isKindOfClass:[NSString class]]) {
                self.index = [model intValue];
                [self searchCusData];
                [self changeStoreView:NO];
                return;
            }
        }
    };
    [cusV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        if (isVertical) {
            make.height.mas_equalTo(self.cHeight*0.8);
            make.left.equalTo(self.view).offset(0);
        }else{
            make.height.mas_equalTo(self.cWidth);
            make.width.mas_equalTo(self.cWidth);
        }
    }];
    if (self.chooseArr.count>0) {
        cusV.dataArr = self.chooseArr;
    }
    if (self.dataNum.count>0) {
        cusV.dataNum = self.dataNum;
    }
    self.chooseV = cusV;
    
    [self creatCustomPopView:isVertical];
}
//快速定制弹出页面
- (void)creatCustomPopView:(BOOL)isVertical{
    if (self.customV) {
        [self.customV removeFromSuperview];
        self.customV = nil;
    }
    NewCustomizationView *popCus = [[NewCustomizationView alloc]initWithPop:NO];
    [self.view addSubview:popCus];
    popCus.isH = isVertical;
    popCus.back = ^(BOOL isDef, id model) {
        if (!isDef) {
            if (![model isKindOfClass:[NSString class]]) {
                NewCustomizationInfo *info = (NewCustomizationInfo*)model;
                self.dataNum = info.modelPartCount;
                [self.chooseArr setObject:info atIndexedSubscript:self.index];
                [self.searchPids setObject:info.pid atIndexedSubscript:self.index];
                if ([YQObjectBool boolForObject:info.selectProItem]) {
                    self.headInfo = [NewCustomizationHeadInfo mj_objectWithKeyValues:info.selectProItem];
                    [self creatCusTomHeadView:self.headInfo.modelPic];
                    [self setupHeadView];
                }
                self.chooseV.dataArr = self.chooseArr;
                self.chooseV.dataNum = self.dataNum;
            }
            [self changeStoreView:YES];
        }
    };
    [popCus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(self.height);
        if (isVertical) {
            make.height.mas_equalTo(self.cHeight*0.8);
            make.left.equalTo(self.view).offset(0);
        }else{
            make.height.mas_equalTo(self.cWidth);
            make.width.mas_equalTo(self.cWidth);
        }
    }];
    if (self.customArr.count>0) {
        popCus.dataArr = self.customArr;
    }
    popCus.layer.shadowColor = [UIColor blackColor].CGColor;
    popCus.layer.shadowOpacity = 0.3f;
    popCus.layer.shadowRadius = 10.f;
    popCus.layer.shadowOffset = CGSizeMake(0,-20);
    self.customV = popCus;
}

- (void)changeStoreView:(BOOL)isClose{
    BOOL isHi = YES;
    if (self.height==1000) {
        if (isClose) {
            return;
        }
        self.height = 0;
        isHi = NO;
    }else{
        self.height = 1000;
        isHi = YES;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.customV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(self.height);
        }];
        [self.view layoutIfNeeded];//强制绘制
    }];
}

@end
