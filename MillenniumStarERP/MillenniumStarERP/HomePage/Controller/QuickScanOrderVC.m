//
//  QuickScanOrderVC.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/1/31.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "QuickScanOrderVC.h"
#import "HYBLoopScrollView.h"
#import "DetailModel.h"
#import "QuickScanTableCell.h"
#import "CustomDriFirstCell.h"
#import "CustomPickView.h"
#import "CustomPopView.h"
@interface QuickScanOrderVC ()<UINavigationControllerDelegate,UITableViewDataSource,
                               UITableViewDelegate,MWPhotoBrowserDelegate>
@property (nonatomic,  weak)UITableView *tableView;
@property (nonatomic,  weak) IBOutlet UIButton *lookBtn;
@property (nonatomic,  weak) IBOutlet UIButton *addBtn;
@property (nonatomic,  weak) IBOutlet UILabel *numLab;
@property (nonatomic,  copy)NSArray *IDarray;
@property (nonatomic,  copy)NSArray *headImg;
@property (nonatomic,  copy)NSArray *photos;
@property (nonatomic,  copy)NSArray *colours;
@property (nonatomic,  copy)NSArray *handArr;
@property (nonatomic,  copy)NSString *handStr;
@property (nonatomic,  copy)NSString *proNum;
@property (nonatomic,assign)float wid;
@property (nonatomic,strong)UIView *hView;
@property (nonatomic,  weak)CustomPickView *pickView;
@property (nonatomic,  weak)CustomPopView *popView;
@property (nonatomic,strong)DetailModel *modelInfo;
@property (nonatomic,strong)DetailTypeInfo *colorInfo;
@end

@implementation QuickScanOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBaseView];
}

- (void)setupBaseView{
    self.wid = IsPhone?0.5:0.65;
    self.proNum = @"1";
    [self setBaseTableView];
    [self setupQuickData];
    [self creatNaviBtn];
    [self setupPopView];
    [self.numLab setLayerWithW:8 andColor:BordColor andBackW:0.001];
    [self.lookBtn setLayerWithW:5 andColor:BordColor andBackW:0.5];
    [self.addBtn setLayerWithW:5 andColor:BordColor andBackW:0.001];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
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
    table.estimatedRowHeight = 200;
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

- (void)setupQuickData{
    NSString *regiUrl = [NSString stringWithFormat:@"%@ModelDetailPageForSCanCode",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"keyword"] = self.scanCode;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [self setDetailDataWithDic:response.data];
        }else{
            [MBProgressHUD showError:response.message];
        }
    } requestURL:regiUrl params:params];
}

- (void)setDetailDataWithDic:(NSDictionary *)data{
    if ([YQObjectBool boolForObject:data[@"modelPuritys"]]) {
        self.colours = data[@"modelPuritys"];
        if (self.colours.count==1) {
            self.colorInfo = [DetailTypeInfo mj_objectWithKeyValues:self.colours[0]];
        }
    }
    if ([YQObjectBool boolForObject:data[@"model"]]) {
        DetailModel *modelIn = [DetailModel mj_objectWithKeyValues:
                                data[@"model"]];
        self.modelInfo = modelIn;
        [self creatCusTomHeadView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
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
#pragma mark --头视图滑动视图--
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
    self.hView = headView;
    if (isHead) {
        self.tableView.tableHeaderView = self.hView;
    }else{
        [self.view addSubview:self.hView];
        [self.view sendSubviewToBack:self.hView];
    }
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

#pragma mark -tableviewDataSource-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuickScanTableCell *scanCell = [QuickScanTableCell cellWithTableView:tableView];
    scanCell.MessBack = ^(BOOL isSel,NSString *messArr){
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
    scanCell.colur = self.colorInfo.title;
    scanCell.modelInfo = self.modelInfo;
    scanCell.messArr = self.proNum;
    scanCell.handSize = self.handStr;
    return scanCell;
}

#pragma mark -- CustomPopView
//- (void)setupPickView{
//    CustomPickView *popV = [[CustomPickView alloc]init];
//    popV.popBack = ^(int staue,id dict){
//        DetailTypeInfo *info = [dict allValues][0];
//        if (staue==1) {
//            if (info.title.length>0) {
//                self.colorInfo = info;
//            }
//        }else if (staue==2){
//            self.handStr = info.title;
//        }
//        [self.tableView reloadData];
//        [self dismissCustomPopView];
//    };
//    [self.view addSubview:popV];
//    [popV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(0);
//        make.left.equalTo(self.view).offset(0);
//        make.right.equalTo(self.view).offset(0);
//        make.bottom.equalTo(self.view).offset(0);
//    }];
//    self.pickView = popV;
//    [self dismissCustomPopView];
//}

- (void)setupPopView{
    CustomPopView *popV = [[CustomPopView alloc]init];
    popV.popBack = ^(id dict){
        DetailTypeInfo *info = [dict allValues][0];
        if (info.title.length>0) {
            self.colorInfo = info;
        }
        [self.tableView reloadData];
        [self dismissCustomPopView];
    };
    [self.view addSubview:popV];
    [popV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.popView = popV;
    [self dismissCustomPopView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissCustomPopView];
}

- (void)openNumberAndhandSize:(int)staue and:(NSIndexPath *)index{
    self.popView.titleStr = @"请选择成色";
    self.popView.typeList = self.colours;
    [self showCustomPopView];
//    if (staue==2) {
//        self.pickView.typeList = self.handArr;
//        NSString *title = self.handStr.length>0?self.handStr:@"12";
//        self.pickView.titleStr = @"手寸";
//        self.pickView.selTitle = title;
//    }else{
//        if (self.colours.count==0) {
//            [MBProgressHUD showError:@"暂无数据"];
//            return;
//        }
//        self.pickView.titleStr = @"成色";
//        self.pickView.typeList = self.colours;
//        self.pickView.selTitle = self.colorInfo.title;
//    }
//    self.pickView.section = index;
//    self.pickView.staue = staue;
//    [self showCustomPopView];
}

- (void)showCustomPopView{
//    self.pickView.hidden = NO;
    self.popView.hidden = NO;
//    [UIView animateWithDuration:0.5 animations:^{
//        [self.popView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view).offset(0);
//        }];
//        [self.popView layoutIfNeeded];//强制绘制
//    }];
}

- (void)dismissCustomPopView{
//    self.pickView.hidden = YES;
    self.popView.hidden = YES;
//    [UIView animateWithDuration:0.5 animations:^{
//        [self.popView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view).offset(2*SDevWidth);
//        }];
//        [self.popView layoutIfNeeded];//强制绘制
//    }];
}

- (IBAction)lookClick:(id)sender {
    
}

- (IBAction)addClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
