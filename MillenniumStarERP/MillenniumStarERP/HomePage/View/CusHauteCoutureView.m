//
//  CusHauteCoutureView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/8/8.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "CusHauteCoutureView.h"
#import "AddressInfo.h"
#import "CustomerInfo.h"
#import "ProductInfo.h"
#import "DetailTypeInfo.h"
#import "ProductListVC.h"
#import "StrWithIntTool.h"
#import "ConfirmOrderVC.h"
#import "ProductionOrderVC.h"
#import "ShowLoginViewTool.h"
#import "PayViewController.h"
#import "ChangeUserInfoVC.h"
#import "NakedDriSearchVC.h"
#import "NakedDriSeaListInfo.h"
#import "NewCustomProDetailVC.h"
#import "NakedDriLibViewController.h"
@interface CusHauteCoutureView()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *staueLab;
@property (weak, nonatomic) IBOutlet UIButton *proBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UIButton *driBtn;
@property (weak, nonatomic) IBOutlet UIButton *messBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *cusLab;
@property (weak, nonatomic) IBOutlet UIButton *conBtn;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2H;
@property (weak, nonatomic) IBOutlet UILabel *proPic;
@property (weak, nonatomic) IBOutlet UILabel *driPic;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *handsLab;
@property (weak, nonatomic) IBOutlet UIButton *reBtn;
@end
@implementation CusHauteCoutureView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"CusHauteCoutureView" owner:nil options:nil][0];
        [self createBase];
    }
    return self;
}

- (void)createBase{
    self.line1H.constant = 0.5;
    self.line2H.constant = 0.5;
    self.infoView.backgroundColor = CUSTOM_COLOR_ALPHA(8, 11, 18, 0.7);
    self.myView.backgroundColor = CUSTOM_COLOR_ALPHA(8, 11, 18, 0.7);
    [self.image setLayerWithW:3 andColor:BordColor andBackW:0.0001];
    [self.proBtn setLayerWithW:3 andColor:[UIColor whiteColor] andBackW:0.5];
    [self.driBtn setLayerWithW:3 andColor:[UIColor whiteColor] andBackW:0.5];
    [self.messBtn setLayerWithW:3 andColor:[UIColor whiteColor] andBackW:0.5];
    [self.reBtn setLayerWithW:3 andColor:BordColor andBackW:0.0001];
    [self.conBtn setLayerWithW:3 andColor:BordColor andBackW:0.0001];
    [self.infoView setLayerWithW:3 andColor:BordColor andBackW:0.0001];
    [self.myView setLayerWithW:3 andColor:BordColor andBackW:0.0001];
    //        单击手势
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self.image addGestureRecognizer:singleRecognizer];
    //        右滑手势
    UISwipeGestureRecognizer * recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self addGestureRecognizer:recognizer];
    //        左滑手势
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self addGestureRecognizer:recognizer];
    
    [self addNotification];
    StorageDataTool *data = [StorageDataTool shared];
    [self reSetProctInfo:data];
    [self reSetNakedInfo:data];
    [self reSetColorInfo:data];
    [self reSetHandsSize:data];
    [self reSetCusInfo:data];
    [self reSetAddInfo:data];
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickConfirm:)
                                                name:NotificationClickName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeNakedDri:)
                                                name:NotificationDriName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRingHolder:)
                                                name:NotificationRingName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeColour:)
                                                name:NotificationColourName object:nil];
}
//修改戒托
- (void)changeRingHolder:(NSNotification *)notification{
    ProductInfo *info = notification.userInfo[UserInfoRingName];
    StorageDataTool *data = [StorageDataTool shared];
    data.BaseInfo = info;
    data.colorInfo = nil;
    data.handSize = @"";
    data.word = @"";
    self.handsLab.hidden = YES;
    self.staueLab.hidden = YES;
    [self reSetProctInfo:data];
}
//修改裸石
- (void)changeNakedDri:(NSNotification *)notification{
    NakedDriSeaListInfo *listInfo = notification.userInfo[UserInfoDriName];
    StorageDataTool *data = [StorageDataTool shared];
    data.BaseSeaInfo = listInfo;
    [self reSetNakedInfo:data];
    [self viewDidShow];
    if (data.BaseInfo) {
        if (data.cusInfo) {
            [MBProgressHUD showSuccess:@"已选择完毕,请点确认定制"];
        }else{
            [MBProgressHUD showSuccess:@"请继续选择信息"];
        }
    }else{
        [MBProgressHUD showSuccess:@"请继续挑选戒托"];
    }
}
//修改成色
- (void)changeColour:(NSNotification *)notification{
    DetailTypeInfo *info = notification.userInfo[UserInfoColourName];
    StorageDataTool *data = [StorageDataTool shared];
    data.colorInfo = info;
    [self reSetColorInfo:data];
}

- (void)clickConfirm:(NSNotification *)notification{
    StorageDataTool *data = [StorageDataTool shared];
    [self reSetHandsSize:data];
    [self viewDidShow];
    if (data.BaseSeaInfo) {
        if (data.cusInfo) {
            [MBProgressHUD showSuccess:@"已选择完毕,请点确认定制"];
        }else{
            [MBProgressHUD showSuccess:@"请继续选择信息"];
        }
    }else{
        [MBProgressHUD showSuccess:@"请继续挑选裸钻"];
    }
}
//赋值
- (void)reSetProctInfo:(StorageDataTool *)data{
    if (data.BaseInfo) {
        self.image.hidden = NO;
        self.title.hidden = NO;
        self.proPic.hidden = NO;
        [self.image sd_setImageWithURL:[NSURL URLWithString:data.BaseInfo.pic]
                      placeholderImage:DefaultImage];
        self.title.text = data.BaseInfo.title;
        float price = data.BaseInfo.price;
        self.proPic.text = [NSString stringWithFormat:@"价格:%0.0f元",price];
        if (data.BaseSeaInfo) {
            price = price+[data.BaseSeaInfo.Price floatValue];
        }
        self.priceLab.text = [NSString stringWithFormat:@"合计:%0.0f元",price];
    }
}

- (void)reSetNakedInfo:(StorageDataTool *)data{
    if (data.BaseSeaInfo) {
        self.infoLab.hidden = NO;
        self.driPic.hidden = NO;
        NSArray *infoArr = @[@"钻石",data.BaseSeaInfo.Weight,data.BaseSeaInfo.Shape,
         data.BaseSeaInfo.Color,data.BaseSeaInfo.Purity,@"1粒",data.BaseSeaInfo.CertCode];
        NSArray *titleArr = @[@"类型",@"规格",@"形状",@"颜色",@"净度",@"数量",@"证书编号"];
        NSMutableArray *mutA = [NSMutableArray new];
        for (int i=0; i<titleArr.count; i++) {
                NSString *strT = infoArr[i];
                if (strT.length>0) {
                    NSString *str = [NSString stringWithFormat:@"%@:%@",titleArr[i],strT];
                    [mutA addObject:str];
            }
        }
        self.infoLab.text = [StrWithIntTool strWithArr:mutA With:@","];
        float price = [data.BaseSeaInfo.Price floatValue];
        self.driPic.text = [NSString stringWithFormat:@"价格:%0.0f元",price];
        if (data.BaseInfo) {
            price = price+data.BaseInfo.price;
        }
        self.priceLab.text = [NSString stringWithFormat:@"合计:%0.0f元",price];
    }
}

- (void)reSetHandsSize:(StorageDataTool *)data{
    NSMutableString *mutS = [NSMutableString new];
    if (data.handSize.length>0) {
        [mutS appendString:[NSString stringWithFormat:@"手寸:%@",data.handSize]];
    }
    if (data.word.length>0) {
        [mutS appendString:[NSString stringWithFormat:@" 字印:%@",data.word]];
    }
    self.handsLab.hidden = NO;
    self.handsLab.text = mutS.copy;
}

- (void)reSetAddInfo:(StorageDataTool *)data{
    if (data.addInfo) {
        self.addressLab.hidden = NO;
        self.addressLab.text = [NSString stringWithFormat:@"地址:%@ %@ %@",
                        data.addInfo.name,data.addInfo.phone,data.addInfo.addr];
    }
}

- (void)reSetCusInfo:(StorageDataTool *)data{
    if (data.cusInfo) {
        self.cusLab.hidden = NO;
        self.cusLab.text = [NSString stringWithFormat:@"客户:%@",data.cusInfo.customerName];
    }
}

- (void)reSetColorInfo:(StorageDataTool *)data{
    if (data.colorInfo) {
        self.staueLab.hidden = NO;
        self.staueLab.text = [NSString stringWithFormat:@"质量:精品 成色:%@",data.colorInfo.title];
    }
}
//显示与隐藏页面
- (void)viewDidShow{
    if (!self.sureBtn.selected) {
        return;
    }
    self.sureBtn.selected = NO;
    if (self.driBack) {
        self.driBack(0,NO);
    }
}

- (void)viewDidDismiss{
    if (self.sureBtn.selected) {
        return;
    }
    self.sureBtn.selected = YES;
    if (self.driBack) {
        self.driBack(0,YES);
    }
}

- (IBAction)showClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.driBack) {
        self.driBack(0,sender.selected);
    }
}

- (void)SingleTap:(UITapGestureRecognizer*)recognizer{
    StorageDataTool *data = [StorageDataTool shared];
    if (!data.BaseInfo) {
        return;
    }
    [self viewDidDismiss];
    UIViewController *cur = [ShowLoginViewTool getCurrentVC];
    if ([cur isKindOfClass:[NewCustomProDetailVC class]]) {
        return;
    }
    NewCustomProDetailVC *list;
    for (UIViewController *vc in cur.navigationController.viewControllers) {
        if ([vc isKindOfClass:[NewCustomProDetailVC class]]) {
            list = (NewCustomProDetailVC *)vc;
        }
    }
    if (list) {
        list.proId = data.BaseInfo.id;
        list.isCus = YES;
        [cur.navigationController popToViewController:list animated:YES];
    }else{
        list = [NewCustomProDetailVC new];
        list.isCus = YES;
        list.proId = data.BaseInfo.id;
        [cur.navigationController pushViewController:list animated:YES];
    }
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self viewDidDismiss];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self viewDidShow];
    }
}
#pragma mark -- 跳转与确认定制按钮
//选择戒托
- (IBAction)openPuct:(id)sender {
    [self viewDidDismiss];
    UIViewController *cur = [ShowLoginViewTool getCurrentVC];
    if ([cur isKindOfClass:[ProductListVC class]]) {
        return;
    }
    StorageDataTool *data = [StorageDataTool shared];
    ProductListVC *list;
    for (UIViewController *vc in cur.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ProductListVC class]]) {
            list = (ProductListVC *)vc;
        }
    }
    NSMutableDictionary *mutB = @{}.mutableCopy;
    if (data.BaseSeaInfo) {
        NSDictionary *dic = data.BaseSeaInfo.modelWeightRange;
        mutB[dic[@"key"]] = dic[@"value"];
    }
    if (list) {
        list.isCus = YES;
        list.backDict = mutB;
        list.isRefresh = YES;
        [cur.navigationController popToViewController:list animated:YES];
    }else{
        list = [ProductListVC new];
        list.backDict = mutB;
        list.isCus = YES;
        [cur.navigationController pushViewController:list animated:YES];
    }
}
//选择裸钻
- (IBAction)openDriClick:(id)sender {
    [self viewDidDismiss];
    UIViewController *cur = [ShowLoginViewTool getCurrentVC];
    StorageDataTool *data = [StorageDataTool shared];
    BOOL isYes = data.BaseInfo==nil;
    [self gotoNakedLibVC:cur and:!isYes];
}

//跳转搜索裸钻页面
- (void)gotoNakedLibVC:(UIViewController *)cur and:(BOOL)isYes{
    StorageDataTool *data = [StorageDataTool shared];
    if ([cur isKindOfClass:[NakedDriLibViewController class]]) {
        return;
    }
    NakedDriLibViewController *driVc;
    for (UIViewController *vc in cur.navigationController.viewControllers) {
        if ([vc isKindOfClass:[NakedDriLibViewController class]]) {
            driVc = (NakedDriLibViewController *)vc;
        }
    }
    if (driVc) {
        driVc.cusType = 3;
        if (data.BaseInfo) {
            driVc.seaDic = data.BaseInfo.stoneWeightRange;
        }
        [cur.navigationController popToViewController:driVc animated:YES];
    }else{
        driVc = [NakedDriLibViewController new];
        driVc.cusType = 3;
        if (data.BaseInfo) {
            driVc.seaDic = data.BaseInfo.stoneWeightRange;
        }
        [cur.navigationController pushViewController:driVc animated:YES];
    }
}
//选择客户信息
- (IBAction)chooseMessage:(id)sender {
    [self viewDidDismiss];
    UIViewController *cur = [ShowLoginViewTool getCurrentVC];
    if ([cur isKindOfClass:[ChangeUserInfoVC class]]) {
        return;
    }
    ChangeUserInfoVC *list = list = [ChangeUserInfoVC new];
    list.back = ^(NSDictionary *dic){
        StorageDataTool *data = [StorageDataTool shared];
        data.addInfo = dic[@"add"];
        data.cusInfo = dic[@"cus"];
        [self reSetCusInfo:data];
        [self reSetAddInfo:data];
        [self viewDidShow];
        if (data.BaseInfo) {
            if (data.cusInfo) {
                [MBProgressHUD showSuccess:@"已选择完毕,请点确认定制"];
            }else{
                [MBProgressHUD showSuccess:@"请继续挑选钻石"];
            }
        }else{
            [MBProgressHUD showSuccess:@"请继续挑选戒托"];
        }
    };
    [cur.navigationController pushViewController:list animated:YES];
}
//确认定制
- (IBAction)confirmClick:(id)sender{
    self.conBtn.enabled = NO;
    [self performSelector:@selector(changeButtonStatus)withObject:nil afterDelay:1.0f];//防止重复点击
    [self openConfirmOrder];
}

- (void)changeButtonStatus{
    self.conBtn.enabled =YES;
}

- (void)openConfirmOrder{
    StorageDataTool *data = [StorageDataTool shared];
    if (!data.BaseInfo) {
        [MBProgressHUD showError:@"请挑选戒托"];
        return;
    }
    if (!data.colorInfo) {
        [MBProgressHUD showError:@"请选择成色"];
        return;
    }
    if (!data.BaseSeaInfo) {
        [MBProgressHUD showError:@"请挑选钻石"];
        return;
    }
    if (!data.cusInfo) {
        [MBProgressHUD showError:@"请选择客户信息"];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@OrderCurrentSubmitQuickNowDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"productId"] = @(data.BaseInfo.id);
    params[@"number"] = @1;
    params[@"modelQualityId"] = @1;
    if (data.word.length>0) {
        params[@"word"] = data.word;
    }
    if (data.note.length>0) {
        params[@"remarks"] = data.note;
    }
    params[@"customerID"] = @(data.cusInfo.customerID);
    params[@"modelPurityId"] = @(data.colorInfo.id);
    if (data.handSize.length>0) {
        params[@"handSize"] = data.handSize;
    }
    params[@"jewelStoneId"] = data.BaseSeaInfo.id;
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:@"提交成功"];
            if ([YQObjectBool boolForObject:response.data]&&
                [YQObjectBool boolForObject:response.data[@"waitOrderCount"]]) {
                App;
                app.shopNum = [response.data[@"waitOrderCount"]intValue];
            }
            [self gotoNextViewConter:response.data];
        }else{
            [MBProgressHUD showError:response.message];
        }
    } requestURL:url params:params];
}
//是否需要付款 是否下单ERP
- (void)gotoNextViewConter:(id)dic{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UIViewController *cur = [ShowLoginViewTool getCurrentVC];
    if ([dic[@"isNeetPay"]intValue]==1) {
        PayViewController *payVc = [PayViewController new];
        payVc.orderId = dic[@"orderNum"];
        [cur.navigationController pushViewController:payVc animated:YES];
    }else{
        if ([dic[@"isErpOrder"]intValue]==0) {
            ConfirmOrderVC *oDetailVc = [ConfirmOrderVC new];
            oDetailVc.isOrd = YES;
            oDetailVc.editId = [dic[@"id"] intValue];
            [cur.navigationController pushViewController:oDetailVc animated:YES];
        }else{
            ProductionOrderVC *proVc = [ProductionOrderVC new];
            proVc.isOrd = YES;
            proVc.orderNum = dic[@"orderNum"];
            [cur.navigationController pushViewController:proVc animated:YES];
        }
    }
    [self setDataEmpty];
    if (self.driBack) {
        self.driBack(1,YES);
    }
}

- (IBAction)reSetData:(id)sender {
    [self setDataEmpty];
    self.image.hidden = YES;
    self.title.hidden = YES;
    self.staueLab.hidden = YES;
    self.handsLab.hidden = YES;
    self.infoLab.hidden = YES;
    self.proPic.hidden = YES;
    self.driPic.hidden = YES;
    self.priceLab.text = @"合计:";
}

- (void)setDataEmpty{
    StorageDataTool *data = [StorageDataTool shared];
    data.colorInfo = nil;
    data.note = nil;
    data.handSize = nil;
    data.word = nil;
    data.BaseInfo = nil;
    data.BaseSeaInfo = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
