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
#import "CustomPickView.h"
#import "OrderListInfo.h"
#import "NewCustomizationSureVC.h"
#import "NewCustomizationHeadInfo.h"
#import "NakedDriLibViewController.h"
#import "CustomJewelInfo.h"
@interface NewCustomizationVC ()<UINavigationControllerDelegate>
@property (nonatomic,assign)int height;
@property (nonatomic,assign)int cHeight;
@property (nonatomic,assign)int cWidth;
@property (nonatomic,assign)int index;
@property (nonatomic,assign)BOOL isCh;
@property (nonatomic,assign)BOOL isWait;
@property (nonatomic,assign)float numPer;
@property (nonatomic,strong)NSMutableArray *searchPids;
@property (nonatomic,strong)NSMutableArray *chooseArr;
@property (nonatomic,strong)NewCustomizationHeadInfo*headInfo;
@property (nonatomic,strong)CustomPickView *pickView;
@property (nonatomic,strong)NSMutableDictionary *driInfo;
@property (nonatomic,  copy)NSArray *headImg;
@property (nonatomic,  copy)NSArray *IDarray;
@property (nonatomic,  copy)NSArray *customArr;
@property (nonatomic,  copy)NSArray *puritys;
@property (nonatomic,  copy)NSArray *dataNum;
@property (nonatomic,  copy)NSArray *handArr;
@property (nonatomic,  copy)NSString *handStr;
@property (nonatomic,  weak)NewCustomizationView *chooseV;
@property (nonatomic,  weak)NewCustomizationView *customV;
@property (nonatomic,  weak)HYBLoopScrollView *loopHead;
@property (weak, nonatomic) IBOutlet UIView *bottomSureBtn;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bottomBtns;
@end

@implementation NewCustomizationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Design of style";
    [_bottomSureBtn setLayerWithW:0.0001 andColor:LineColor andBackW:0.5];
    self.height = 1000;
    self.numPer = 0.8;
    self.driInfo = @{}.mutableCopy;
    [self loadHomeData];
    [self setupPopView];
    [self creatNaviBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeNakedDri:)
                                                name:NotificationDriName object:nil];
}
//修改裸石
- (void)changeNakedDri:(NSNotification *)notification{
    NakedDriSeaListInfo *listInfo = notification.userInfo[UserInfoDriName];
    NSArray *infoArr = @[@"钻石",listInfo.Weight,listInfo.Shape,listInfo.Color,
                         listInfo.Purity,listInfo.CertCode];
    [self setDefalutCustomViewWith:infoArr andId:listInfo.id andInfo:listInfo.Price];
}

- (void)addStoneWithDic:(NSDictionary *)data{
    CustomJewelInfo *CusInfo = [CustomJewelInfo mj_objectWithKeyValues:data];
    NSArray *infoArr = @[@"钻石",CusInfo.jewelStoneWeight,CusInfo.jewelStoneShape,
                         CusInfo.jewelStoneColor,CusInfo.jewelStonePurity,CusInfo.jewelStoneCode];
    [self setDefalutCustomViewWith:infoArr andId:CusInfo.jewelStoneId
                           andInfo:CusInfo.jewelStonePrice];
}

- (void)setDefalutCustomViewWith:(NSArray *)infoArr andId:(NSString *)codeId andInfo:(NSString *)price{
    NSArray *type = @[@"类型:",@"重量:",@"形状:",@"颜色:",@"净度:",@"证书号:"];
    NSMutableArray *mutA = @[].mutableCopy;
    for (int i=0; i<infoArr.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%@%@",type[i],infoArr[i]];
        [mutA addObject:str];
    }
    self.driInfo[@"info"] = [StrWithIntTool strWithArr:mutA With:@","];
    self.driInfo[@"codeId"] = codeId;
    self.driInfo[@"price"] = price;
    self.chooseV.drillInfo = self.driInfo[@"info"];
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

- (void)orientChange:(NSNotification *)notification{
    [self dismissCustomPopView];
    self.bottomSureBtn.alpha = 0;
    [self changeTableHeadView];
    [self setupHeadView];
    [self creatBaseView];
}
#pragma mark -- 网络请求
- (void)loadHomeData{
    self.searchPids = @[].mutableCopy;
    self.chooseArr  = @[].mutableCopy;
    [SVProgressHUD show];
    NSString *detail;
    if (self.isEd==1) {
        detail = @"CustomDetailPageForCurrentOrderEditPage";
    }else if (self.isEd==2){
        detail = @"CustomDetailPageForWaitCheckEditPage";
    }else{
        detail = @"CreateCustomItem";
    }
    NSString *netUrl = [NSString stringWithFormat:@"%@%@",baseUrl,detail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    if (self.proId>0) {
        params[@"itemId"] = @(self.proId);
    }
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        self.isWait = YES;
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"modelItem"]]) {
                self.headInfo = [NewCustomizationHeadInfo mj_objectWithKeyValues:response.data[@"modelItem"]];
                [self creatCusTomHeadView:self.headInfo.modelPic];
                [self changeTableHeadView];
                [self setupHeadView];
                [self creatBaseView];
                if ([self.headInfo.id intValue]>0) {
                    [self setHandSizeForStr:self.headInfo.handSize];
                }
            }
            if ([YQObjectBool boolForObject:response.data[@"modelParts"]]) {
                NSArray *arr = [NewCustomizationInfo mj_objectArrayWithKeyValuesArray:response.data[@"modelParts"]];
                [self.chooseArr addObjectsFromArray:arr];
                self.chooseV.dataArr = self.chooseArr;
                for (NewCustomizationInfo *info in arr) {
                    if ([self.headInfo.id intValue]>0) {
                        [self.searchPids addObject:info.pid];
                    }else{
                        [self.searchPids addObject:@""];
                    }
                }
            }
            if ([YQObjectBool boolForObject:response.data[@"jewelStone"]]) {
                [self addStoneWithDic:response.data[@"jewelStone"]];
            }else{
                self.driInfo[@"info"] = @"选择裸钻";
                self.driInfo[@"codeId"] = @"";
                self.driInfo[@"price"] = @"";
                self.chooseV.drillInfo = self.driInfo[@"info"];
            }
            if ([YQObjectBool boolForObject:response.data[@"modelpartCount"]]) {
                self.dataNum = response.data[@"modelpartCount"];
                self.chooseV.dataNum = self.dataNum;
            }
            if ([YQObjectBool boolForObject:response.data[@"modelPuritys"]]) {
                self.puritys = response.data[@"modelPuritys"];
            }
            if ([YQObjectBool boolForObject:response.data[@"handSizeData"]]) {
                NSMutableArray *mutA = [NSMutableArray new];
                for (NSString *title in response.data[@"handSizeData"]) {
                    [mutA addObject:@{@"title":title}];
                }
                self.handArr = mutA.copy;
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
        self.numPer = 0.8;
    }else{
        self.cWidth = SDevHeight;
        if (!IsPhone){
            self.cWidth = SDevWidth*0.4;
        }
    }
}

- (void)setupHeadView{
    BOOL isVertical = SDevHeight>SDevWidth;
    if (self.loopHead) {
        [self.loopHead removeFromSuperview];
        self.loopHead = nil;
    }
    CGRect headF = CGRectMake(0, 0, SDevWidth-self.cWidth, SDevHeight);
    if (!IsPhone){
        headF = CGRectMake(0, 20, SDevWidth*0.6, SDevHeight-20);
    }
    if (isVertical) {
        headF = CGRectMake(0, 0, SDevWidth, SDevHeight-self.cHeight*self.numPer-40);
    }
    HYBLoopScrollView *loop = [HYBLoopScrollView loopScrollViewWithFrame:
                               headF imageUrls:self.headImg];
    loop.timeInterval = 6.0;
    loop.imgMode = UIViewContentModeScaleAspectFit;
    loop.didSelectItemBlock = ^(NSInteger atIndex,HYBLoadImageView  *sender){
        //        [self imageTapGestureWithIndex:atIndex];
    };
    loop.alignment = kPageControlAlignRight;
    [self.view addSubview:loop];
    [self.view sendSubviewToBack:loop];
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
                [UIView animateWithDuration:0.2 animations:^{
                    self.bottomSureBtn.alpha = 0;
                    self.chooseV.btn.alpha = 1;
                }];
                [self changeStoreView:NO];
            }else if([model isEqualToString:@"完成"]){
                [self setBottomPrice];
                if ([self.driInfo[@"codeId"]length]==0) {
                    [MBProgressHUD showError:@"请选择裸钻"];
                    return;
                }
                [self showRemindMessage:YES];
            }else if([model isEqualToString:@"重置"]){
                if (!self.isWait) {
                    return;
                }
                [self loadHomeData];
                self.isWait = NO;
            }else if([model isEqualToString:@"选择裸钻"]){
                [self showRemindMessage:NO];
            }
        }
    };
    [cusV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        if (isVertical) {
            make.height.mas_equalTo(self.cHeight*self.numPer+40);
            make.left.equalTo(self.view).offset(0);
        }else{
            make.height.mas_equalTo(SDevHeight-20);
            make.width.mas_equalTo(self.cWidth);
        }
    }];
    if (self.chooseArr.count>0) {
        cusV.dataArr = self.chooseArr;
    }
    if (self.dataNum.count>0) {
        cusV.dataNum = self.dataNum;
    }
    if ([self.driInfo[@"info"]length]!=0){
        cusV.drillInfo = self.driInfo[@"info"];
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
            if ([model isKindOfClass:[NSString class]]){
                if([model isEqualToString:@"删除"]){
                    [MBProgressHUD showError:@"点击了删除"];
                }
            }else{
                NewCustomizationInfo *info = (NewCustomizationInfo*)model;
                self.dataNum = info.modelPartCount;
                [self.chooseArr setObject:info atIndexedSubscript:self.index];
                [self.searchPids setObject:info.pid atIndexedSubscript:self.index];
                if ([YQObjectBool boolForObject:info.selectProItem]) {
                    NewCustomizationHeadInfo *newInfo = [NewCustomizationHeadInfo
                                         mj_objectWithKeyValues:info.selectProItem];
                    if ([newInfo.stoneWeightRange[@"value"]length]!=0&&![newInfo.stoneWeightRange[@"value"] isEqualToString:self.headInfo.stoneWeightRange[@"value"]]) {
                        self.driInfo[@"info"] = @"选择裸钻";
                        self.driInfo[@"codeId"] = @"";
                        self.driInfo[@"price"] = @"";
                        self.chooseV.drillInfo = self.driInfo[@"info"];
                    }
                    if (self.headInfo.id!=newInfo.id) {
                        self.headInfo = newInfo;
                        [self creatCusTomHeadView:self.headInfo.modelPic];
                        [self setupHeadView];
                    }
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
            make.height.mas_equalTo(self.cHeight*self.numPer+40);
            make.left.equalTo(self.view).offset(0);
        }else{
            make.height.mas_equalTo(SDevHeight-20);
            make.width.mas_equalTo(self.cWidth);
        }
    }];
    if (self.customArr.count>0) {
        popCus.dataArr = self.customArr;
    }
    if (isVertical) {
        popCus.layer.shadowColor = [UIColor blackColor].CGColor;
        popCus.layer.shadowOpacity = 0.3f;
        popCus.layer.shadowRadius = 10.f;
        popCus.layer.shadowOffset = CGSizeMake(0,-20);
    }
    self.customV = popCus;
}

- (void)changeStoreView:(BOOL)isClose{
    if (self.height==1000) {
        if (isClose) {
            return;
        }
        self.height = 0;
    }else{
        self.height = 1000;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.customV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(self.height);
        }];
        [self.view layoutIfNeeded];//强制绘制
    }];
}
#pragma mark -- CustomPopView 选择手寸
- (void)setupPopView{
    CustomPickView *popV = [[CustomPickView alloc]init];
    popV.popBack = ^(int staue,id dict){
        DetailTypeInfo *info = [dict allValues][0];
        if (staue==2){
            [self setHandSizeForStr:info.title];
        }
        [self dismissCustomPopView];
    };
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

- (void)setHandSizeForStr:(NSString *)str{
    if (str.length==0) {
        return;
    }
    self.handStr = str;
    UIButton *btn = self.bottomBtns[0];
    NSString *title = [NSString stringWithFormat:@"选择手寸(%@)",self.handStr];
    [btn setTitle:title forState:UIControlStateNormal];
}

- (void)setBottomPrice{
    NSString *str = self.isEd?@"确定":@"购买";
    UIButton *btn = self.bottomBtns[1];
    float price = self.headInfo.price+[self.driInfo[@"price"]floatValue];
    NSString *title = [NSString stringWithFormat:@"%@￥%0.0f",str,price];
    [btn setTitle:title forState:UIControlStateNormal];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissCustomPopView];
}

- (void)openHandSize{
    self.pickView.typeList = self.handArr;
    NSString *title = self.handStr.length>0?self.handStr:@"12";
    self.pickView.isCus = YES;
    self.pickView.titleStr = @"手寸";
    self.pickView.selTitle = title;
    self.pickView.section = [NSIndexPath indexPathForRow:0 inSection:0];
    self.pickView.staue = 2;
    [self showCustomPopView];
}

- (void)showCustomPopView{
    [self.view bringSubviewToFront:self.pickView];
    self.pickView.hidden = NO;
}

- (void)dismissCustomPopView{
    self.pickView.hidden = YES;
}

- (void)showRemindMessage:(BOOL)isDri{
    if ([self.headInfo.id intValue]==0) {
        NSMutableArray *mutA = @[].mutableCopy;
        for (NewCustomizationInfo *info in self.chooseArr) {
            if (info.pid.length==0) {
                [mutA addObject:info.title];
            }
        }
        NSString *str = [NSString stringWithFormat:@"请选择%@",
                         [StrWithIntTool strWithArr:mutA With:@","]];
        [MBProgressHUD showError:str];
    }else{
        if (isDri) {
            [self.view bringSubviewToFront:self.bottomSureBtn];
            [UIView animateWithDuration:1 animations:^{
                self.bottomSureBtn.alpha = 1;
                self.chooseV.btn.alpha = 0;
            }];
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                self.bottomSureBtn.alpha = 0;
                self.chooseV.btn.alpha = 1;
            }];
            NakedDriLibViewController *driVc = [NakedDriLibViewController new];
            driVc.cusType = 2;
            driVc.seaDic = self.headInfo.stoneWeightRange;
            [self.navigationController pushViewController:driVc animated:YES];
        }
    }
}

- (IBAction)bottomClick:(UIButton *)sender {
    NSInteger idex = [self.bottomBtns indexOfObject:sender];
    if (idex==0) {
        [self openHandSize];
    }else{
        [SVProgressHUD show];
        sender.enabled = NO;
        NSString *detail;
        if (self.isEd==1) {
            detail = @"OrderCurrentEditModelItemForCustomDo";
        }else if (self.isEd==2){
            detail = @"CustomDetailPageForWaitCheckEditDo";
        }else{
            detail = @"OrderCurrentDoModelItemForCustomDo";
        }
        NSString *netUrl = [NSString stringWithFormat:@"%@%@",baseUrl,detail];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"tokenKey"] = [AccountTool account].tokenKey;
        params[@"productId"] = self.headInfo.id;
        params[@"handSize"] = self.handStr;
        params[@"number"] = @1;
        params[@"jewelStoneId"] = self.driInfo[@"codeId"];
        if (self.isEd) {
            params[@"itemId"] = @(self.proId);
        }
        [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
            if ([response.error intValue]==0) {
                if (self.isEd) {
                    [self loadEditType:response.data];
                    return;
                }
                NewCustomizationSureVC *sureVc = [NewCustomizationSureVC new];
                [self.navigationController pushViewController:sureVc animated:YES];
            }else{
                [MBProgressHUD showError:response.message];
            }
            sender.enabled = YES;
        } requestURL:netUrl params:params];
    }
}

- (void)loadEditType:(NSDictionary *)data{
    OrderListInfo *listI = [OrderListInfo mj_objectWithKeyValues:data];
    if (self.back) {
        self.back(listI);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
