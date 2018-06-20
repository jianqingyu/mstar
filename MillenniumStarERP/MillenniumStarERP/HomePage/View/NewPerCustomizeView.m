//
//  NewPerCustomizeView.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/5/14.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "NewPerCustomizeView.h"
#import "NewCustomCrossView.h"
#import "NewCustomCrossSelView.h"
#import "CustomPickView.h"
#import "ShowLoginViewTool.h"
#import "StrWithIntTool.h"
#import "NewCustomPublicInfo.h"
#import "NewCustomizationInfo.h"
#import "NakedDriLibViewController.h"
@interface NewPerCustomizeView()
@property (nonatomic,strong)NewCustomPublicInfo *publicInfo;
@property (nonatomic,  weak)NewCustomCrossView *crossV;
@property (nonatomic,  weak)NewCustomCrossSelView *crossSelV;
@property (nonatomic,  weak)CustomPickView *pickView;
@property (nonatomic,assign)CGFloat backH;
@property (nonatomic,assign)int selIndex;
@property (nonatomic,  copy)NSArray *chooseTitle;
@end
@implementation NewPerCustomizeView

- (id)init{
    self = [super init];
    if (self) {
        self.backH = MIN(SDevWidth, SDevHeight);
        self.chooseTitle = @[@"请选择头",@"请选择接口",@"请选择圈"];
        [self createBaseView];
        [self creatNaviBtn];
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
    [self bringSubviewToFront:btn];
}

- (void)backClick{
    UIViewController *curVc = [ShowLoginViewTool getCurrentVC];
    [curVc.navigationController popViewControllerAnimated:YES];
}

- (void)setupData{
    self.publicInfo = [NewCustomPublicInfo shared];
    [self.crossV setSmallData];
}

- (void)setupDriInfo:(NSDictionary *)driDic{
    [self.crossV setDriInfo:driDic];
}

- (void)createBaseView{
    UIImageView *baImage = [[UIImageView alloc]initWithImage:
                            [UIImage imageNamed:@"cushome_bg.jpg"]];
    [self addSubview:baImage];
    [baImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    
    NewCustomCrossView *crossView = [NewCustomCrossView new];
    crossView.back = ^(int type, BOOL isItem) {
        [self callBack:type andData:isItem];
    };
    [self addSubview:crossView];
    [crossView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(self.backH);
    }];
    self.crossV = crossView;
    
    NewCustomCrossSelView *crossSelView = [NewCustomCrossSelView new];
    crossSelView.back = ^(BOOL isSel, id model) {
        [self selCrossSelView:isSel and:model];
    };
    [self addSubview:crossSelView];
    [crossSelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.height.mas_equalTo(0);
    }];
    self.crossSelV = crossSelView;
}

- (void)callBack:(int)type andData:(BOOL)isItem{
    if (isItem) {
        self.selIndex = type;
        [self.publicInfo searchCusData:type andBack:^{
            self.crossSelV.data = self.publicInfo.chooseArr;
            self.crossSelV.str = self.chooseTitle[type];
            [self dismissOrShow:YES];
        }];
    }else{
        if (type==3) {
            [self showRemindMessage];
        }else{
            [self bottomClick:type];
        }
    }
}

- (void)selCrossSelView:(BOOL)isSel and:(id)model{
    if (isSel) {
        NewCustomizationInfo *info = (NewCustomizationInfo*)model;
        self.publicInfo.numberArr = info.modelPartCount;
        [self.publicInfo.baseArr setObject:info atIndexedSubscript:self.selIndex];
        [self.publicInfo.searchPids setObject:info.pid atIndexedSubscript:self.selIndex];
        if ([YQObjectBool boolForObject:info.selectProItem]) {
            [self.publicInfo chooseLitleData:info.selectProItem];
        }
        [self.crossV setSmallData];
    }else if([model isEqualToString:@"清除"]){
        [self.publicInfo.searchPids setObject:@"" atIndexedSubscript:self.selIndex];
        [self.publicInfo loadDefalutData:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.crossV setSmallData];
            });
        }];
    }
    [self dismissOrShow:NO];
}

- (void)dismissOrShow:(BOOL)isShow{
    if (isShow) {
        [self setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.5 animations:^{
            [self.crossV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            self.crossV.croBtmView.hidden = YES;
            [self.crossSelV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.backH);
            }];
            [self layoutIfNeeded];
        }];
    }else{
        [self setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.5 animations:^{
            [self.crossV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.backH);
            }];
            self.crossV.croBtmView.hidden = NO;
            [self.crossSelV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            [self layoutIfNeeded];//强制绘制
        }];
    }
}

- (void)showRemindMessage{
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
        NakedDriLibViewController *driVc = [NakedDriLibViewController new];
        driVc.cusType = 2;
        driVc.seaDic = self.publicInfo.modelItem[@"stoneWeightRange"];
        UIViewController *curVc = [ShowLoginViewTool getCurrentVC];
        [curVc.navigationController pushViewController:driVc animated:YES];
    }
}
#pragma mark -- CustomPopView 选择手寸
- (void)setupPopView{
    CustomPickView *popV = [[CustomPickView alloc]init];
    popV.popBack = ^(int staue,id dict){
        DetailTypeInfo *info = [dict allValues][0];
        if (staue==2){
            self.publicInfo.handSize = info.title;
            [self.crossV setBottomData];
        }
        [self dismissCustomPopView];
    };
    [self addSubview:popV];
    [popV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(256);
        make.left.equalTo(self).offset(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
        make.bottom.equalTo(self).offset(0);
    }];
    self.pickView = popV;
    [self dismissCustomPopView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
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

- (void)bottomClick:(int)idex{
    if (idex==5) {
        [self openHandSize];
    }else if(idex==6){
        if ([self.publicInfo.driData[@"codeId"]length]==0) {
            [MBProgressHUD showError:@"请选择裸钻"];
            return;
        }
        [self.publicInfo confirmData:^(id model) {
            if (self.back) {
                self.back(model);
            }
        }];
    }else if(idex==7){
        [self.publicInfo loadHomeData:^{
            [self.crossV setSmallData];
        }];
    }
}

@end
