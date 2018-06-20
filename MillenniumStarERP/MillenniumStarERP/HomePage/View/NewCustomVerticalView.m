//
//  NewCustomVerticalView.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/5/16.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "NewCustomVerticalView.h"
#import "HYBLoopScrollView.h"
#import "NewCustomizationHeadInfo.h"
#import "NewCustomizationInfo.h"
#import "NewCustomizationView.h"
#import "NakedDriLibViewController.h"
#import "ShowLoginViewTool.h"
#import "CustomPickView.h"
#import "StrWithIntTool.h"
#import "NewCustomPublicInfo.h"
@interface NewCustomVerticalView()
@property (nonatomic,strong)CustomPickView *pickView;
@property (nonatomic,  weak)NewCustomPublicInfo *publicInfo;
@property (nonatomic,  weak)NewCustomizationView *baseView;
@property (nonatomic,  weak)NewCustomizationView *choosePopView;
@property (nonatomic,  weak)HYBLoopScrollView *loopHead;
@property (nonatomic,  weak)UIView *bottomView;
@property (nonatomic,  weak)UIButton *hanBtn;
@property (nonatomic,  weak)UIButton *sureBtn;
@property (nonatomic,assign)CGFloat popHeight;
@property (nonatomic,assign)int selIndex;
@end
@implementation NewCustomVerticalView

- (id)init{
    self = [super init];
    if (self) {
        self.popHeight = 1000;
        [self creatNaviBtn];
        [self createBottomView];
        [self setupPopView];
    }
    return self;
}

- (void)creatNaviBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 20, 54, 54);
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [self addSubview:btn];
}

- (void)backClick{
    UIViewController *curVc = [ShowLoginViewTool getCurrentVC];
    [curVc.navigationController popViewControllerAnimated:YES];
}

- (void)createBottomView{
    UIView *btmView = [UIView new];
    btmView.backgroundColor = [UIColor whiteColor];
    [self addSubview:btmView];
    [btmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.height.mas_equalTo(40);
    }];
    UIButton *btn1 = [self createBtnWithTitle:@"选择手寸" andIndex:1 andSuv:btmView];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btmView).offset(0);
        make.left.equalTo(btmView).offset(0);
        make.bottom.equalTo(btmView).offset(0);
        make.width.mas_equalTo(btmView.mas_width).multipliedBy(0.5);
    }];
    self.hanBtn = btn1;
    
    UIButton *btn2 = [self createBtnWithTitle:@"确定" andIndex:2 andSuv:btmView];
    btn2.backgroundColor = MAIN_COLOR;
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btmView).offset(0);
        make.right.equalTo(btmView).offset(0);
        make.bottom.equalTo(btmView).offset(0);
        make.width.mas_equalTo(btmView.mas_width).multipliedBy(0.5);
    }];
    self.sureBtn = btn2;
    self.bottomView = btmView;
}

- (UIButton *)createBtnWithTitle:(NSString *)title andIndex:(int)index
                          andSuv:(UIView *)baView{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.tag = index;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(botBtnClick:)
               forControlEvents:UIControlEventTouchUpInside];
    [baView addSubview:btn];
    return btn;
}

- (void)setupData{
    NewCustomPublicInfo *info = [NewCustomPublicInfo shared];
    self.publicInfo = info;
    [self setupHeadView:info.imgArr];
    [self creatBaseView:info.baseArr];
    [self creatCustomPopView:info.chooseArr];
    if ([info.modelItem[@"handSize"] length]>0) {
        [self setHandSizeForStr:info.modelItem[@"handSize"]];
    }else if(info.handSize.length>0){
        [self setHandSizeForStr:info.handSize];
    }
    if ([info.driData[@"info"]length]>0) {
        self.baseView.drillInfo = info.driData[@"info"];
    }
}

- (void)setupDriInfo:(NSDictionary *)driDic{
    [self.publicInfo changeDriInfo:driDic];
    if ([self.publicInfo.driData[@"info"]length]>0) {
        self.baseView.drillInfo = self.publicInfo.driData[@"info"];
    }
}

#pragma mark - 初始化头视图与滑动页面
- (void)setupHeadView:(NSArray *)imageArr{
    if (self.loopHead) {
        [self.loopHead removeFromSuperview];
        self.loopHead = nil;
    }
    CGRect headF = CGRectMake(0, 0, SDevWidth, SDevHeight-SDevWidth*0.8-40);
    HYBLoopScrollView *loop = [HYBLoopScrollView loopScrollViewWithFrame:
                               headF imageUrls:imageArr];
    loop.timeInterval = 6.0;
    loop.imgMode = UIViewContentModeScaleAspectFit;
    loop.didSelectItemBlock = ^(NSInteger atIndex,HYBLoadImageView *sender){
        
    };
    loop.alignment = kPageControlAlignRight;
    [self addSubview:loop];
    [self sendSubviewToBack:loop];
    self.loopHead = loop;
}

- (void)setHandSizeForStr:(NSString *)str{
    if (str.length==0) {
        return;
    }
    self.publicInfo.handSize = str;
    NSString *title = [NSString stringWithFormat:@"选择手寸(%@)",str];
    [self.hanBtn setTitle:title forState:UIControlStateNormal];
}

- (void)creatBaseView:(NSArray *)arr{
    if (self.baseView) {
        [self.baseView removeFromSuperview];
        self.baseView = nil;
    }
    NewCustomizationView *cusV = [[NewCustomizationView alloc]initWithPop:YES];
    [self addSubview:cusV];
    cusV.back = ^(BOOL isDef, id model) {
        if (isDef) {
            if (![model isKindOfClass:[NSString class]]) {
                self.selIndex = [model intValue];
                [self.publicInfo searchCusData:self.selIndex andBack:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.choosePopView.dataArr = self.publicInfo.chooseArr;
                        [UIView animateWithDuration:0.2 animations:^{
                            self.bottomView.alpha = 0;
                            self.baseView.btn.alpha = 1;
                        }];
                        [self changeStoreView:NO];
                    });
                }];
            }else if([model isEqualToString:@"完成"]){
                [self setBottomPrice];
                if ([self.publicInfo.driData[@"codeId"]length]==0) {
                    [MBProgressHUD showError:@"请选择裸钻"];
                    return;
                }
                [self showRemindMessage:YES];
            }else if([model isEqualToString:@"重置"]){
                [self.publicInfo loadHomeData:^{
                    [self setupHeadView:self.publicInfo.imgArr];
                    self.baseView.dataArr = self.publicInfo.baseArr;
                    if ([self.publicInfo.modelItem[@"handSize"] length]>0) {
                        [self setHandSizeForStr:self.publicInfo.modelItem[@"handSize"]];
                    }
                    if ([self.publicInfo.driData[@"info"]length]>0) {
                        self.baseView.drillInfo = self.publicInfo.driData[@"info"];
                    }
                }];
            }else if([model isEqualToString:@"选择裸钻"]){
                [self showRemindMessage:NO];
            }
        }
    };
    [cusV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.height.mas_equalTo(SDevWidth*0.8+40);
        make.left.equalTo(self).offset(0);
    }];
    if (arr.count>0) {
        cusV.dataArr = arr;
    }
    if (self.publicInfo.numberArr.count>0) {
        cusV.dataNum = self.publicInfo.numberArr;
    }
    if ([self.publicInfo.driData[@"info"] length]!=0){
        cusV.drillInfo = self.publicInfo.driData[@"info"];
    }
    self.baseView = cusV;
}
//快速定制弹出页面
- (void)creatCustomPopView:(NSArray *)popArr{
    if (self.choosePopView) {
        [self.choosePopView removeFromSuperview];
        self.choosePopView = nil;
    }
    NewCustomizationView *popCus = [[NewCustomizationView alloc]initWithPop:NO];
    [self addSubview:popCus];
    popCus.back = ^(BOOL isDef, id model) {
        if (!isDef) {
            if ([model isKindOfClass:[NSString class]]){
                if([model isEqualToString:@"删除"]){
                    [self.publicInfo.searchPids setObject:@"" atIndexedSubscript:self.selIndex];
                    [self.publicInfo loadDefalutData:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self setupHeadView:self.publicInfo.imgArr];
                            self.baseView.dataArr = self.publicInfo.baseArr;
                        });
                    }];
                }
            }else{
                NewCustomizationInfo *info = (NewCustomizationInfo*)model;
                self.publicInfo.numberArr = info.modelPartCount;
                [self.publicInfo.baseArr setObject:info atIndexedSubscript:self.selIndex];
                [self.publicInfo.searchPids setObject:info.pid atIndexedSubscript:self.selIndex];
                if ([YQObjectBool boolForObject:info.selectProItem]) {
                    BOOL isCh = [self.publicInfo chooseLitleData:info.selectProItem];
                    if (isCh) {
                        [self setupHeadView:self.publicInfo.imgArr];
                    }
                }
                self.baseView.dataArr = self.publicInfo.baseArr;
                self.baseView.dataNum = self.publicInfo.numberArr;
            }
            [self changeStoreView:YES];
        }
    };
    [popCus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(self.popHeight);
        make.height.mas_equalTo(SDevWidth*0.8+40);
        make.left.equalTo(self).offset(0);
    }];
    if (popArr.count>0) {
        popCus.dataArr = popArr;
    }
    popCus.layer.shadowColor   = [UIColor blackColor].CGColor;
    popCus.layer.shadowOpacity = 0.3f;
    popCus.layer.shadowRadius  = 10.f;
    popCus.layer.shadowOffset  = CGSizeMake(0,-20);
    self.choosePopView = popCus;
}

- (void)changeStoreView:(BOOL)isClose{
    if (self.popHeight==1000) {
        if (isClose) {
            return;
        }
        self.popHeight = 0;
    }else{
        self.popHeight = 1000;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.choosePopView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(self.popHeight);
        }];
        [self.choosePopView layoutIfNeeded];//强制绘制
    }];
}

- (void)setBottomPrice{
    int isEd = [self.publicInfo.netData[@"isEd"] intValue];
    float pri = [self.publicInfo.modelItem[@"price"]floatValue];
    NSDictionary *dic = self.publicInfo.driData;
    NSString *str = isEd?@"确定":@"购买";
    float price = pri+[dic[@"price"] floatValue];
    NSString *title = [NSString stringWithFormat:@"%@￥%0.0f",str,price];
    [self.sureBtn setTitle:title forState:UIControlStateNormal];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissCustomPopView];
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
    [self addSubview:popV];
    [popV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    self.pickView = popV;
    [self dismissCustomPopView];
}

- (void)openHandSize{
    self.pickView.typeList = self.publicInfo.handSizeArr;
    NSString *title = self.publicInfo.handSize?self.publicInfo.handSize:@"12";
    self.pickView.isCus = YES;
    self.pickView.titleStr = @"手寸";
    self.pickView.selTitle = title;
    self.pickView.section  = [NSIndexPath indexPathForRow:0 inSection:0];
    self.pickView.staue    = 2;
    [self showCustomPopView];
}

- (void)showCustomPopView{
    [self bringSubviewToFront:self.pickView];
    self.pickView.hidden = NO;
}

- (void)dismissCustomPopView{
    self.pickView.hidden = YES;
}

- (void)showRemindMessage:(BOOL)isDri{
    if ([self.publicInfo.modelItem[@"id"] intValue]==0) {
        NSMutableArray *mutA = @[].mutableCopy;
        for (NewCustomizationInfo *info in self.publicInfo.baseArr) {
            if (info.pid.length==0) {
                [mutA addObject:info.title];
            }
        }
        NSString *str = [NSString stringWithFormat:@"请选择%@",
                         [StrWithIntTool strWithArr:mutA With:@","]];
        [MBProgressHUD showError:str];
    }else{
        if (isDri) {
            [self bringSubviewToFront:self.bottomView];
            [UIView animateWithDuration:1 animations:^{
                self.bottomView.alpha = 1;
                self.baseView.btn.alpha = 0;
            }];
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                self.bottomView.alpha = 0;
                self.baseView.btn.alpha = 1;
            }];
            NakedDriLibViewController *driVc = [NakedDriLibViewController new];
            driVc.cusType = 2;
            driVc.seaDic = self.publicInfo.modelItem[@"stoneWeightRange"];
            UIViewController *curVc = [ShowLoginViewTool getCurrentVC];
            [curVc.navigationController pushViewController:driVc animated:YES];
        }
    }
}

- (void)botBtnClick:(UIButton *)btn{
    NSInteger idex = btn.tag;
    if (idex==1) {
        [self openHandSize];
    }else{
        [self.publicInfo confirmData:^(id model) {
            if (self.back) {
                self.back(model);
            }
        }];
    }
}

@end
