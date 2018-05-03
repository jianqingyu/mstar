//
//  NewCustomProDetailVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/7/14.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NewCustomProDetailVC.h"
#import "ConfirmOrderVC.h"
#import "CustomFirstCell.h"
#import "NewCustomProCell.h"
#import "CustomLastCell.h"
#import "MWPhotoBrowser.h"
#import "DetailTypeInfo.h"
#import "DetailModel.h"
#import "DetailTypeInfo.h"
#import "OrderListInfo.h"
#import "DetailHeadInfo.h"
#import "StrWithIntTool.h"
#import "CommonUtils.h"
#import "CustomJewelInfo.h"
#import "CustomPickView.h"
#import "HYBLoopScrollView.h"
#import "CustomDriFirstCell.h"
#import "ChooseNakedDriVC.h"
#import "CustomDriWordCell.h"
#import "CustomShowView.h"
#import "SaveColorData.h"
#import "SetDriViewController.h"
#import "StatisticNumberVC.h"
#import "FMDataTool.h"
#import "SetDriInfo.h"
#import "StaticNumInfo.h"
#import "ConfirmOrderCollectionVC.h"
@interface NewCustomProDetailVC ()<UINavigationControllerDelegate,UITableViewDelegate,
UITableViewDataSource,MWPhotoBrowserDelegate>
@property (nonatomic,  weak) UITableView *tableView;
@property (nonatomic,  weak) IBOutlet UIButton *lookBtn;
@property (nonatomic,  weak) IBOutlet UIButton *addBtn;
@property (nonatomic,  weak) IBOutlet UILabel *numLab;
@property (nonatomic,  weak) IBOutlet UILabel *priceLab;
@property (nonatomic,  weak) IBOutlet UILabel *allLab;
@property (weak,  nonatomic) IBOutlet UIButton *staticBtn;

@property (nonatomic,assign)int isCan;
@property (nonatomic,assign)int idx;
@property (nonatomic,assign)float wid;
@property (nonatomic,assign)int isResh;
@property (nonatomic,assign)BOOL isNote;
@property (nonatomic,assign)BOOL isError;

@property (nonatomic,  copy)NSString *proNum;
@property (nonatomic,  copy)NSString *handStr;
@property (nonatomic,  copy)NSString *driWord;
@property (nonatomic,  copy)NSString *lastMess;
@property (nonatomic,  copy)NSString *driCode;
@property (nonatomic,  copy)NSString *driPrice;
@property (nonatomic,  copy)NSString *driId;

@property (nonatomic,  copy)NSArray *typeArr;
@property (nonatomic,  copy)NSArray *typeSArr;
@property (nonatomic,  copy)NSArray *detailArr;
@property (nonatomic,  copy)NSArray *remakeArr;
@property (nonatomic,  copy)NSArray *IDarray;
@property (nonatomic,  copy)NSArray *headImg;
@property (nonatomic,  copy)NSArray *photos;
@property (nonatomic,  copy)NSArray *specTitles;
@property (nonatomic,  copy)NSArray *handArr;
@property (nonatomic,  copy)NSArray *puritys;
@property (nonatomic,  copy)NSArray *chooseArr;
@property (nonatomic,  copy)NSArray *rangeArr;

@property (nonatomic,strong)NSDictionary*stoneDic;
@property (nonatomic,strong)NSMutableArray*bools;
@property (nonatomic,strong)NSMutableArray*mutArr;
@property (nonatomic,strong)NSMutableArray*nums;

@property (nonatomic,strong)UIView *hView;
@property (nonatomic,strong)DetailModel *modelInfo;

@property (nonatomic,strong)CustomPickView *pickView;
@property (nonatomic,  weak)CustomShowView *wordView;
@end

@implementation NewCustomProDetailVC
//简单模式下单
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定制信息";
    [self loadBaseCustomView];
    self.wid = IsPhone?0.5:0.65;
}

- (void)loadBaseCustomView{
    self.proNum = @"1";
    self.idx = self.isCus?3:2;
    
    [OrderNumTool setCircularWithPath:self.numLab size:CGSizeMake(16, 16)];
    [self.staticBtn setLayerWithW:5 andColor:BordColor andBackW:0.5];
    [self.lookBtn setLayerWithW:5 andColor:BordColor andBackW:0.5];
    [self.addBtn setLayerWithW:5 andColor:BordColor andBackW:0.0001];
    
    self.lookBtn.hidden = self.isCus;
    self.staticBtn.hidden = self.isCus;
    self.priceLab.hidden = [[AccountTool account].isNoShow intValue];
    self.allLab.hidden = [[AccountTool account].isNoShow intValue];
    [self.priceLab setAdjustsFontSizeToFitWidth:YES];
    [self.numLab setAdjustsFontSizeToFitWidth:YES];
    if (self.isCus) {
        [self.addBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    if (self.isEdit) {
        [self.lookBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.addBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    self.nums = @[@"1",@"1",@"1",@"1"].mutableCopy;
    self.bools = @[@NO,@NO,@NO,@NO].mutableCopy;
    self.typeArr = @[@"主   石",@"副石A",@"副石B",@"副石C"];
    self.typeSArr = @[@"stone",@"stoneA",@"stoneB",@"stoneC"];
    self.mutArr = @[].mutableCopy;
    [self setBaseTableView];
    [self setupDetailData];
    [self setupPopView];
    [self creatNaviBtn];
    [self creatNearNetView:^(BOOL isWifi) {
        [self setupDetailData];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(changeNakedDri:)
                                                name:NotificationDriName object:nil];
}
//修改裸石
- (void)changeNakedDri:(NSNotification *)notification{
    NakedDriSeaListInfo *listInfo = notification.userInfo[UserInfoDriName];
    NSArray *infoArr = @[@"钻石",listInfo.Weight,[self modelWith:2 and:listInfo.Shape],
        [self modelWith:3 and:listInfo.Color],[self modelWith:4 and:listInfo.Purity]];
    NSArray *arr = self.mutArr[0];
    for (int i=0; i<arr.count; i++) {
        DetailTypeInfo *info = arr[i];
        info.id = 1;
        info.title = infoArr[i];
    }
    [self.nums setObject:@"1" atIndexedSubscript:0];
    self.driCode = listInfo.CertCode;
    self.driPrice = listInfo.Price;
    self.driId = listInfo.id;
    self.proNum = @"1";
    [self.tableView reloadData];
}

- (void)setBaseNakedDriSeaInfo{
    if (!self.seaInfo) {
        return;
    }
    NakedDriSeaListInfo *listInfo = self.seaInfo;
    NSArray *infoArr =  @[@"钻石",listInfo.Weight,
                         [self modelWith:2 and:listInfo.Shape],
                         [self modelWith:3 and:listInfo.Color],
                         [self modelWith:4 and:listInfo.Purity]];
    NSArray *arr = self.mutArr[0];
    for (int i=0; i<arr.count; i++) {
        DetailTypeInfo *info = arr[i];
        info.id = 1;
        info.title = infoArr[i];
    }
    [self.nums setObject:@"1" atIndexedSubscript:0];
    self.driCode = listInfo.CertCode;
    self.driPrice = listInfo.Price;
    self.driId = listInfo.id;
    self.proNum = @"1";
    [self.tableView reloadData];
}

- (void)addStoneWithDic:(NSDictionary *)data{
    CustomJewelInfo *CusInfo = [CustomJewelInfo mj_objectWithKeyValues:data];
    NSArray *infoArr = @[@"钻石",CusInfo.jewelStoneWeight,
                        [self modelWith:2 and:CusInfo.jewelStoneShape],
                        [self modelWith:3 and:CusInfo.jewelStoneColor],
                        [self modelWith:4 and:CusInfo.jewelStonePurity]];
    NSMutableArray *mutA = [NSMutableArray new];
    for (int i=0; i<5; i++) {
        DetailTypeInfo *info = [DetailTypeInfo new];
        info.id = 1;
        info.title = infoArr[i];
        [mutA addObject:info];
    }
    self.driCode = CusInfo.jewelStoneCode;
    self.driPrice = CusInfo.jewelStonePrice;
    self.driId = CusInfo.jewelStoneId;
    self.proNum = @"1";
    [self.mutArr addObject:mutA];
    [self.tableView reloadData];
}

- (NSString *)modelWith:(int)idx and:(NSString *)obj{
    NSString *str = obj;
    if (idx>self.chooseArr.count) {
        return str;
    }
    if (![YQObjectBool boolForObject:obj]) {
        DetailTypeInfo *info = self.chooseArr[idx][0];
        str = info.title;
    }
    return str;
}

- (void)orientChange:(NSNotification *)notification{
    [self changeTableHeadView];
    [self.tableView reloadData];
}

- (void)changeTableHeadView{
    if (SDevHeight>SDevWidth) {
        [self.hView removeFromSuperview];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(0);
        }];
        [self setupHeadView:self.headImg and:YES];
    }else{
        self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(SDevWidth*self.wid);
        }];
        [self setupHeadView:self.headImg and:NO];
    }
}

- (void)setBaseTableView{
    UITableView *table = [[UITableView alloc]init];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    table.bounces = NO;
    table.rowHeight = UITableViewAutomaticDimension;
    table.estimatedRowHeight = 125;
    [self.view addSubview:table];
    CGFloat headF = 0;
    if (!IsPhone){
        headF = 20;
    }
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(headF);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    self.tableView = table;
    CGRect frame = CGRectMake(0, 0, SDevWidth, 10);
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:frame];
}

//- (void)creatSetDriBtn{
//    if (!self.hView) {
//        return;
//    }
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor clearColor];
//    [btn addTarget:self action:@selector(driClick) forControlEvents:UIControlEventTouchUpInside];
//    [btn setImage:[UIImage imageNamed:@"icon_set"] forState:UIControlStateNormal];
//    [self.hView addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.hView).offset(20);
//        make.right.equalTo(self.hView).offset(-10);
//        make.size.mas_equalTo(CGSizeMake(54, 54));
//    }];
//    //    self.setBtn = btn;
//}

- (void)driClick{
    SetDriViewController *driVc = [SetDriViewController new];
    [self.navigationController pushViewController:driVc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    App;
    [OrderNumTool orderWithNum:app.shopNum andView:self.numLab];
    if (self.isCus) {
        self.numLab.hidden = YES;
    }
    self.navigationController.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)creatNaviBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 20, 54, 54);
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- loadData 初始化数据
- (void)scanSearchData:(NSString *)keyword{
    if (self.mutArr.count>0) {
        [self.mutArr removeAllObjects];
    }
    NSString *regiUrl = [NSString stringWithFormat:@"%@ModelDetailPageForSCanCode",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"keyword"] = keyword;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            self.isError = NO;
            [self setDetailDataWithDic:response.data];
        }else{
            self.isError = YES;
            [MBProgressHUD showError:response.message];
        }
    } requestURL:regiUrl params:params];
}

- (void)setupDetailData{
    [SVProgressHUD show];
    if (self.mutArr.count>0) {
        [self.mutArr removeAllObjects];
    }
    NSString *detail;
    if (self.isEdit==1) {
        detail = @"ModelDetailPageForCurrentOrderEditPage";
    }else if (self.isEdit==2){
        detail = @"ModelOrderWaitCheckModelDetailPageForCurrentOrderEditPage";
    }else{
        detail = @"ModelDetailPage";
    }
    NSString *regiUrl = [NSString stringWithFormat:@"%@%@",baseUrl,detail];
    NSString *proId = self.isEdit?@"itemId":@"id";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[proId] = @(_proId);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [self setDetailDataWithDic:response.data];
        }
    } requestURL:regiUrl params:params];
}

- (void)setDetailDataWithDic:(NSDictionary *)data{
    if ([YQObjectBool boolForObject:data[@"IsCanSelectStone"]]) {
        self.isCan = [data[@"IsCanSelectStone"]intValue];
    }
    if ([YQObjectBool boolForObject:data[@"jewelStone"]]) {
        [self addStoneWithDic:data[@"jewelStone"]];
    }
    if ([YQObjectBool boolForObject:data[@"modelPuritys"]]) {
        self.puritys = data[@"modelPuritys"];
        StorageDataTool *stoData = [StorageDataTool shared];
        if (stoData.colorInfo&&_isCus) {
            self.colorInfo = stoData.colorInfo;
        }
        if (self.puritys.count==1) {
            self.colorInfo = [DetailTypeInfo mj_objectWithKeyValues:self.puritys[0]];
        }
    }
    SaveColorData *saveColor = [SaveColorData shared];
    if (!_isCus&&saveColor.colorInfo.title.length>0) {
        self.colorInfo = saveColor.colorInfo;
    }
    if ([YQObjectBool boolForObject:data[@"model"]]) {
        DetailModel *modelIn = [DetailModel mj_objectWithKeyValues:
                                data[@"model"]];
        [self setupBaseListData:modelIn];
        [self creatCusTomHeadView];
        if (([YQObjectBool boolForObject:data[@"model"][@"stoneWeightRange"]]) ) {
            self.stoneDic = data[@"model"][@"stoneWeightRange"];
        }
        if (modelIn.modelPurityTitle.length>0) {
            self.colorInfo = [DetailTypeInfo new];
            self.colorInfo.title = modelIn.modelPurityTitle;
            self.colorInfo.id = modelIn.modelPurityId;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    if ([YQObjectBool boolForObject:data[@"stoneType"]]) {
        self.chooseArr = @[[self arrWithModel:data[@"stoneType"]],
                           [self arrWithModel:data[@"stoneColor"]],
                           [self arrWithModel:data[@"stoneShape"]],
                           [self arrWithModel:data[@"stoneColor"]],
                           [self arrWithModel:data[@"stonePurity"]]];
    }
    if ([YQObjectBool boolForObject:data[@"handSizeData"]]) {
        NSMutableArray *mutA = [NSMutableArray new];
        for (NSString *title in data[@"handSizeData"]) {
            [mutA addObject:@{@"title":title}];
        }
        self.handArr = mutA.copy;
    }
    if ([YQObjectBool boolForObject:data[@"remarks"]]) {
        self.remakeArr = data[@"remarks"];
    }
    [self setBaseNakedDriSeaInfo];
}

- (NSArray *)arrWithModel:(NSDictionary *)dic{
    NSArray *arr = [DetailTypeInfo mj_objectArrayWithKeyValuesArray:dic];
    return arr;
}

- (void)setupBaseListData:(DetailModel *)modelIn{
    self.modelInfo = modelIn;
    self.lastMess = modelIn.remark;
    if (self.isEdit) {
        self.proNum = modelIn.number;
        if (![modelIn.handSize isEqualToString:@"0"]) {
            self.handStr = modelIn.handSize;
        }
    }
    [self setupNumbers:@[modelIn.stone,modelIn.stoneA,
                         modelIn.stoneB,modelIn.stoneC]];
    self.detailArr  = @[[self arrWithDict:modelIn.stone],
                        [self arrWithDict:modelIn.stoneA],
                        [self arrWithDict:modelIn.stoneB],
                        [self arrWithDict:modelIn.stoneC]];
    [self setBaseMutArr];
}

- (void)setBaseMutArr{
    int i=0;
    for (NSArray *arr in self.detailArr) {
        if (i==0&&self.mutArr.count==0) {
            [self setMutAWith:arr];
        }else{
            if (![self boolWithNoArr:arr]) {
                [self setMutAWith:arr];
            }
        }
        i++;
    }
}

- (void)setupNumbers:(NSArray *)stoneArr{
    for (int i=0; i<stoneArr.count; i++) {
        NSDictionary *dict = stoneArr[i];
        if ([YQObjectBool boolForObject:dict[@"number"]]) {
            NSString *numStr = [dict[@"number"] description];
            [self.nums setObject:numStr atIndexedSubscript:i];
        }
    }
}

- (void)setMutAWith:(NSArray *)arr{
    NSMutableArray *mut = [NSMutableArray new];
    for (DetailTypeInfo *new in arr) {
        [mut addObject:[new newInfo]];
    }
    [self.mutArr addObject:mut];
}
//一个石头里面的数据都是空的
- (BOOL)boolWithNoArr:(NSArray *)arr{
    for (DetailTypeInfo *info in arr) {
        if (info.title.length>0) {
            return NO;
        }
    }
    return YES;
}

- (NSMutableArray *)arrWithDict:(NSDictionary *)dict{
    DetailTypeInfo *in1 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"typeTitle"]]) {
        in1.id = [dict[@"typeId"]intValue];
        in1.title = dict[@"typeTitle"];
    }
    DetailTypeInfo *in2 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"specTitle"]]) {
        in2.title = dict[@"specTitle"];
    }
    DetailTypeInfo *in3 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"shapeTitle"]]) {
        in3.id = [dict[@"shapeId"]intValue];
        in3.title = dict[@"shapeTitle"];
    }
    DetailTypeInfo *in4 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"colorTitle"]]) {
        in4.id = [dict[@"colorId"]intValue];
        in4.title = dict[@"colorTitle"];
    }
    DetailTypeInfo *in5 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"purityTitle"]]) {
        in5.id = [dict[@"purityId"]intValue];
        in5.title = dict[@"purityTitle"];
    }
    return @[in1,in2,in3,in4,in5].mutableCopy;
}
#pragma mark - 初始化图片
- (void)creatCusTomHeadView{
    NSMutableArray *pic  = @[].mutableCopy;
    NSMutableArray *mPic = @[].mutableCopy;
    NSMutableArray *bPic = @[].mutableCopy;
    for (NSDictionary*dict in self.modelInfo.pics) {
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
    [self changeTableHeadView];
}

- (NSString *)UsingEncoding:(NSString *)str{
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)setLastMess:(NSString *)lastMess{
    if (lastMess) {
        _lastMess = lastMess;
        if (self.isCus) {
            StorageDataTool *data = [StorageDataTool shared];
            data.note = _lastMess;
        }
    }
}

- (void)setupHeadView:(NSArray *)headArr and:(BOOL)isHead{
    CGRect headF = CGRectMake(0, 0, SDevWidth*self.wid, SDevHeight-60);
    if (!IsPhone){
        headF = CGRectMake(0, 20, SDevWidth*self.wid, SDevHeight-80);
    }
    if (isHead) {
        headF = CGRectMake(0, 0, SDevWidth, SDevWidth);
    }
    //轮播视图
    UIView *headView = [[UIView alloc]initWithFrame:headF];
    CGFloat wid = headView.width;
    CGFloat height = headView.height;
    CGRect frame = CGRectMake(0, 0, wid, height);
    HYBLoopScrollView *loop = [HYBLoopScrollView loopScrollViewWithFrame:
                               frame imageUrls:headArr];
    loop.timeInterval = 6.0;
    loop.didSelectItemBlock = ^(NSInteger atIndex,HYBLoadImageView  *sender){
        [self didImageWithIndex:atIndex];
    };
    loop.alignment = kPageControlAlignRight;
    [headView addSubview:loop];
    //预览视图
    CustomShowView *show = [[CustomShowView alloc]init];
    [headView addSubview:show];
    [show mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headView).offset(0);
        make.right.equalTo(headView).offset(0);
        make.size.mas_equalTo(CGSizeMake(150, 75));
    }];
    show.hidden = YES;
    self.wordView = show;
    
    self.hView = headView;
    if (isHead) {
        self.tableView.tableHeaderView = self.hView;
    }else{
        [self.view addSubview:self.hView];
        [self.view sendSubviewToBack:self.hView];
    }
//    [self creatSetDriBtn];
}

- (void)didImageWithIndex:(NSInteger)index{
    //网络图片展示
    if (self.IDarray.count==0) {
        [MBProgressHUD showError:@"暂无图片"];
        return;
    }
    [self networkImageShow:index];
}

- (void)networkImageShow:(NSUInteger)index{
    NSMutableArray *photos = [NSMutableArray array];
    for (NSString *str in self.IDarray) {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:str]];
        [photos addObject:photo];
    }
    self.photos = [photos copy];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:YES];
}
#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count){
        return [_photos objectAtIndex:index];
    }
    return nil;
}

#pragma mark -- CustomPopView
- (void)setupPopView{
    CustomPickView *popV = [[CustomPickView alloc]init];
    popV.popBack = ^(int staue,id dict){
        DetailTypeInfo *info = [dict allValues][0];
        if (staue==1) {
            if (info.title.length>0) {
                self.colorInfo = info;
                if (self.isCus) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:
                     NotificationColourName object:nil userInfo:@{UserInfoColourName:info}];
                }else{
                    SaveColorData *saveColor = [SaveColorData shared];
                    saveColor.colorInfo = info;
                }
            }
        }else if (staue==2){
            self.handStr = info.title;
            if (self.isCus) {
                StorageDataTool *data = [StorageDataTool shared];
                data.handSize = info.title;
            }else if(info.id==12){
                self.isNote = YES;
            }
        }else if (staue==4){
            self.lastMess = [NSString stringWithFormat:@"%@%@",self.lastMess,info.title];
        }
        [self.tableView reloadData];
        [self dismissCustomPopView];
    };
    popV.isCus = self.isCus;
    [self.view addSubview:popV];
    [popV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.pickView = popV;
    [self dismissCustomPopView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissCustomPopView];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [self updateBottomPrice];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mutArr.count+self.idx;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        if (self.isCus) {
            UITableViewCell *cusCell = [self cellForCus:tableView andIdx:indexPath];
            return cusCell;
        }else{
            UITableViewCell *norCell = [self cellForNor:tableView andIdx:indexPath];
            return norCell;
        }
    }else if (indexPath.row==self.mutArr.count+self.idx-1){
        UITableViewCell *lastCell = [self cellForLast:tableView andIdx:indexPath];
        return lastCell;
    }else{
        UITableViewCell *millCell = [self cellForMil:tableView andIdx:indexPath];
        return millCell;
    }
}
#pragma mark --各种cell--
//快递定制cell
- (UITableViewCell *)cellForCus:(UITableView *)tableView andIdx:(NSIndexPath *)indexPath{
    CustomDriFirstCell *firstCell = [CustomDriFirstCell cellWithTableView:tableView];
    firstCell.MessBack = ^(BOOL isSel,NSString *messArr){
        if (isSel) {
            if ([messArr isEqualToString:@"成色"]) {
                [self openNumberAndhandSize:1 and:indexPath];
            }else{
                self.proNum = messArr;
            }
        }else{
            [self openNumberAndhandSize:2 and:indexPath];
        }
    };
    firstCell.colur = self.colorInfo.title;
    firstCell.modelInfo = self.modelInfo;
    firstCell.messArr = self.proNum;
    firstCell.handSize = self.handStr;
    return firstCell;
}
//正常cell
- (UITableViewCell *)cellForNor:(UITableView *)tableView andIdx:(NSIndexPath *)indexPath{
    CustomFirstCell *firstCell = [CustomFirstCell cellWithTableView:tableView];
    firstCell.MessBack = ^(BOOL isSel,NSString *messArr){
        if (isSel) {
            if ([messArr isEqualToString:@"成色"]) {
                [self openNumberAndhandSize:1 and:indexPath];
            }else{
                self.proNum = messArr;
                [self updateBottomPrice];
            }
        }else{
            if (messArr.length==0) {
                [self openNumberAndhandSize:2 and:indexPath];
            }else{
                [self clearNakedDri];
                self.isResh = 2;
                [self scanSearchData:messArr];
            }
        }
    };
    firstCell.dBack = ^(BOOL isYes){
        [self dismissCustomPopView];
    };
    firstCell.refresh = self.isResh;
    firstCell.editId = self.isEdit;
    firstCell.isNew = YES;
    if (self.driCode) {
        firstCell.certCode = self.driCode;
    }
    firstCell.colur = self.colorInfo.title;
    firstCell.modelInfo = self.modelInfo;
    firstCell.messArr = self.proNum;
    firstCell.handSize = self.handStr;
    self.isResh = 0;
    return firstCell;
}
//底部cell
- (UITableViewCell *)cellForLast:(UITableView *)tableView andIdx:(NSIndexPath *)indexPath{
    CustomLastCell *lastCell = [CustomLastCell cellWithTableView:tableView];
    [lastCell.btn addTarget:self action:@selector(openRemark:)
           forControlEvents:UIControlEventTouchUpInside];
    lastCell.messBack = ^(id message,BOOL isYes){
        if ([message isKindOfClass:[NSString class]]) {
            self.lastMess = message;
        }
        if (isYes) {
            [self addOrder:message];
            self.isResh = 1;
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:
             UITableViewRowAnimationNone];
        }
    };
    lastCell.isNote = self.isNote;
    lastCell.message = self.lastMess;
    self.isNote = NO;
    return lastCell;
}
//中间cell
- (UITableViewCell *)cellForMil:(UITableView *)tableView andIdx:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row-self.idx+1;
    if (self.isCus&&indexPath.row==1) {
        CustomDriWordCell *driCell = [CustomDriWordCell cellWithTableView:tableView];
        driCell.cate = _modelInfo.categoryTitle;
        driCell.word = self.driWord;
        driCell.back = ^(BOOL isSel,NSString *word){
            if (isSel) {
                self.driWord = word;
                StorageDataTool *data = [StorageDataTool shared];
                data.word = word;
            }else{
                self.wordView.wordLab.text = self.driWord;
                self.wordView.hidden = NO;
            }
        };
        return driCell;
    }else{
        NewCustomProCell *proCell = [NewCustomProCell cellWithTableView:tableView];
        proCell.num = self.nums[index];
        proCell.titleStr = self.typeArr[index];
        proCell.list = self.mutArr[index];
        if (self.driCode) {
            proCell.certCode = self.driCode;
        }
        proCell.isSel = [self.bools[index]boolValue];
        proCell.isCus = self.isCus;
        proCell.back = ^(BOOL isSel){
            [self.bools setObject:@(isSel) atIndexedSubscript:index];
        };
        return proCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isCus) {
        return;
    }
    if (indexPath.row==self.idx-1) {
        [self gotoNakedDriLib];
    }
}

- (void)openNumberAndhandSize:(int)staue and:(NSIndexPath *)index{
    if (staue==2) {
        self.pickView.typeList = self.handArr;
        NSString *title = self.handStr.length>0?self.handStr:@"12";
        self.pickView.titleStr = @"手寸";
        self.pickView.selTitle = title;
    }else{
        if (self.puritys.count==0) {
            [MBProgressHUD showError:@"暂无数据"];
            return;
        }
        self.pickView.titleStr = @"成色";
        self.pickView.typeList = self.puritys;
        self.pickView.selTitle = self.colorInfo.title;
    }
    self.pickView.section = index;
    self.pickView.staue = staue;
    [self showCustomPopView];
}

- (void)openRemark:(id)sender{
    if (self.remakeArr.count==0) {
        [MBProgressHUD showError:@"暂无数据"];
        return;
    }
    self.pickView.typeList = self.remakeArr;
    self.pickView.section = [NSIndexPath indexPathForRow:0 inSection:0];
    self.pickView.titleStr = @"备注";
    self.pickView.staue = 4;
    [self showCustomPopView];
}

- (void)showCustomPopView{
    self.pickView.hidden = NO;
}

- (void)dismissCustomPopView{
    self.pickView.hidden = YES;
}

- (void)clearNakedDri{
    self.driPrice = @"";
    self.driCode = @"";
    self.driId = @"";
}

- (void)gotoNakedDriLib{
    ChooseNakedDriVC *libVc = [ChooseNakedDriVC new];
    libVc.isCan = self.isCan;
    libVc.number = self.nums[0];
    libVc.infoArr = self.mutArr[0];
    libVc.seaDic = self.stoneDic;
    libVc.dataArr = [self arrWithDataArr];
    libVc.eidtBack = ^(NSDictionary *dic){
        NSString *num = [dic allKeys][0];
        [self.nums setObject:num atIndexedSubscript:0];
        NSMutableArray *arr = [dic allValues][0];
        [self.mutArr setObject:arr atIndexedSubscript:0];
        [self clearNakedDri];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:libVc animated:YES];
}
//数组里面模型深拷贝
- (NSArray *)arrWithDataArr{
    NSMutableArray *mutA = @[].mutableCopy;
    for (NSArray *arr in self.chooseArr) {
        NSArray *new = [[NSMutableArray alloc] initWithArray:arr copyItems:YES];
        [mutA addObject:new];
    }
    return mutA.copy;
}

- (IBAction)lookStatic:(id)sender {
    StatisticNumberVC *numVc = [StatisticNumberVC new];
    [self.navigationController pushViewController:numVc animated:YES];
}

- (IBAction)lookOrder:(id)sender {
    if (self.isEdit) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    ConfirmOrderCollectionVC *order = [ConfirmOrderCollectionVC new];
    [self.navigationController pushViewController:order animated:YES];
//    ConfirmOrderVC *orderVC = [ConfirmOrderVC new];
//    [self.navigationController pushViewController:orderVC animated:YES];
}
#pragma mark -- 提交订单
- (IBAction)addOrder:(id)sender {
    if (self.isCus) {
        [self customNakedDriAddOrd];
        return;
    }
    if ([self.proNum length]==0) {
        [MBProgressHUD showError:@"请选择件数"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    for (int i=0; i<self.mutArr.count; i++) {
        if ([self.bools[i]boolValue]) {
            params[self.typeSArr[i]] = @"||||||1";
            continue;
        }
        NSMutableArray *arr = self.mutArr[i];
        if ([self boolWithNoArr:arr]) {
            continue;
        }
        [self paramsWithArr:arr andI:i andD:params];
    }
    [self addOrderWithDict:params];
}
//裸钻定制下单
- (void)customNakedDriAddOrd{
    if (!self.colorInfo) {
        [MBProgressHUD showError:@"请选择成色"];
        return;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationClickName
                                object:nil userInfo:@{UserInfoClickName:@"成色"}];
}

- (void)paramsWithArr:(NSArray *)arr andI:(int)i andD:(NSMutableDictionary *)params{
    NSMutableArray *mutA = @[].mutableCopy;
    for (DetailTypeInfo *info in arr) {
        if (info.id) {
            [mutA addObject:@(info.id)];
        }else{
            if (info.title) {
                [mutA addObject:info.title];
            }else{
                [mutA addObject:@""];
            }
        }
    }
    [mutA addObject:self.nums[i]];
    NSString *str = [StrWithIntTool strWithIntOrStrArr:mutA];
    NSString *key = self.typeSArr[i];
    if (![key isEqualToString:@"stone"]) {
        str = [NSString stringWithFormat:@"%@|0",str];
    }
    params[self.typeSArr[i]] = str;
}

- (void)addOrderWithDict:(NSMutableDictionary *)params{
    if (self.isError) {
        [MBProgressHUD showError:@"没有此款号"];
        return;
    }
    NSString *detail;
    if (self.isEdit==1) {
        detail = @"OrderCurrentEditModelItemForDefaultDo";
        params[@"purityId"] = @(self.colorInfo.id);
    }else if (self.isEdit==2){
        detail = @"ModelOrderWaitCheckOrderCurrentEditModelItemForDefaultDo";
    }else{
        detail = @"OrderCurrentDoModelItemForDefaultDo";
        params[@"modelPurityId"] = @(self.colorInfo.id);
        NSArray *values = [[FMDataTool sharedDataBase]getAllSelDriInfo];
        NSMutableArray *mutA = [NSMutableArray new];
        for (SetDriInfo *info in values) {
            [mutA addObject:info.scope];
        }
        self.rangeArr = values;
        params[@"Ranges"] = [StrWithIntTool strWithArr:mutA With:@","];
    }
    NSString *regiUrl = [NSString stringWithFormat:@"%@%@",baseUrl,detail];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    if (self.isEdit) {
        params[@"itemId"] = @(_proId);
    }else{
        params[@"productId"] = _modelInfo.id;
    }
    params[@"number"] = self.proNum;
    if ([self.handStr length]>0) {
        params[@"handSize"] = self.handStr;
    }
    if (self.driId.length>0) {
        params[@"jewelStoneId"] = self.driId;
        params[@"stone"] = @"";
    }
    if (!self.isEdit) {
        params[@"categoryId"] = @(self.modelInfo.categoryId);
    }
    if (self.lastMess.length>0) {
        params[@"remarks"] = self.lastMess;
    }
    [self addOrderData:params andUrl:regiUrl];
}

- (void)addOrderData:(NSMutableDictionary *)params andUrl:(NSString *)netUrl{
    [SVProgressHUD show];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if (self.isEdit) {
                [self loadEditType:response.data];
                return;
            }
            if ([YQObjectBool boolForObject:response.data]) {
                if ([YQObjectBool boolForObject:response.data[@"waitOrderCount"]]&&!self.isCus) {
                    App;
                    app.shopNum = [response.data[@"waitOrderCount"]intValue];
                    [OrderNumTool orderWithNum:app.shopNum andView:self.numLab];
                }
                if ([YQObjectBool boolForObject:response.data[@"range"]]) {
                    NSArray *arr = [StaticNumInfo mj_objectArrayWithKeyValuesArray:
                                    response.data[@"range"]];
                    NSMutableArray *mut = @[].mutableCopy;
                    for (int i=0; i<arr.count; i++) {
                        StaticNumInfo *info = arr[i];
                        SetDriInfo *sInfo = self.rangeArr[i];
                        if (![info.count isEqualToString:@"0"]&&!([info.count intValue]<[sInfo.number intValue])) {
                            [mut addObject:[NSString stringWithFormat:@"%@已经够了",sInfo.scope]];
                        }
                    }
                    [MBProgressHUD showDetail:[StrWithIntTool strWithArr:mut With:@","]];
                    return;
                }
            }
            [MBProgressHUD showSuccess:@"添加订单成功"];
        }else{
            [MBProgressHUD showError:response.message];
        }
    }requestURL:netUrl params:params];
}

- (void)loadEditType:(NSDictionary *)data{
    OrderListInfo *listI = [OrderListInfo mj_objectWithKeyValues:data];
    if (self.orderBack) {
        self.orderBack(listI);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateBottomPrice{
    if (!_modelInfo) {
        return;
    }
    float price = [self.proNum floatValue]*_modelInfo.price;
    if (self.driPrice.length>0) {
        price = price + [self.driPrice floatValue];
    }
    self.priceLab.text = [OrderNumTool strWithPrice:price];
}

@end
