//
//  ChooseNakedDriVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/7/20.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "ChooseNakedDriVC.h"
#import "EditCustomDriView.h"
#import "CustomTitleView.h"
#import "NakedDriLibCustomView.h"
@interface ChooseNakedDriVC ()
@property (nonatomic,  weak)UIButton *editBtn;
@property (nonatomic,  weak)UIButton *nakeBtn;
@property (nonatomic,  weak)EditCustomDriView *editDriV;
@property (nonatomic,  weak)NakedDriLibCustomView *NakedDriV;
@end

@implementation ChooseNakedDriVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNaviTitleView];
    [self creatNakedDriView];
    [self creatEditDriView];
    self.editBtn.enabled = NO;
    self.nakeBtn.enabled = YES;
    if (self.isCan==0) {
        self.nakeBtn.hidden = YES;
        self.NakedDriV.hidden = YES;
    }else if(self.isCan==1){
        self.editBtn.hidden = YES;
        self.nakeBtn.enabled = NO;
        self.editDriV.hidden = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)orientChange:(NSNotification *)notification{
    CGFloat height = SDevWidth>SDevHeight?31:37;
    [self.editBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

- (void)creatNaviTitleView{
    CGFloat width = SDevWidth*0.65;
    CGFloat height = SDevWidth>SDevHeight?31:37;
    CustomTitleView *titleView = [[CustomTitleView alloc]initWithFrame:CGRectMake(0, 0,  width, 30)];
    UIButton *sureBtn = [self setB:@"选择主石规格" andS:65 andV:titleView];
    UIButton *cancelBtn = [self setB:@"裸钻库挑选" andS:66 andV:titleView];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView).offset(0);
        make.height.mas_equalTo(height);
        make.top.equalTo(titleView).offset(0);
        make.width.equalTo(cancelBtn);
        make.right.equalTo(cancelBtn.mas_left).with.offset(0);
    }];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sureBtn.mas_right).offset(0);
        make.height.equalTo(sureBtn);
        make.centerY.mas_equalTo(sureBtn.mas_centerY);
        make.right.equalTo(titleView).offset(0);
        make.width.equalTo(sureBtn);
    }];
    self.navigationItem.titleView = titleView;
    self.editBtn = sureBtn;
    self.nakeBtn = cancelBtn;
}

- (UIButton *)setB:(NSString *)title andS:(int)tag andV:(UIView *)supV{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:MAIN_COLOR forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_line-1"] forState:UIControlStateDisabled];
    [btn addTarget:self action:@selector(topBtnClick:)
                            forControlEvents:UIControlEventTouchUpInside];
    [supV addSubview:btn];
    return btn;
}

- (void)topBtnClick:(UIButton *)btn{
    if (btn.tag==65) {
        [UIView animateWithDuration:0.5 animations:^{
            self.editBtn.enabled = NO;
            self.nakeBtn.enabled = YES;
            self.editDriV.hidden = NO;
            self.NakedDriV.hidden = YES;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.editDriV.hidden = YES;
            self.NakedDriV.hidden = NO;
            self.editBtn.enabled = YES;
            self.nakeBtn.enabled = NO;
        }];
    }
}

- (void)creatEditDriView{
    EditCustomDriView *editDriView = [EditCustomDriView creatCustomView];
    editDriView.number = self.number;
    editDriView.NakedArr = self.dataArr.mutableCopy;
    editDriView.infoArr = self.infoArr;
    editDriView.supNav = self.navigationController;
    editDriView.editBack = ^(id moedel){
        if (self.eidtBack) {
            self.eidtBack(moedel);
        }
    };
    [self.view addSubview:editDriView];
    [editDriView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.editDriV = editDriView;
}

- (void)creatNakedDriView{
    NakedDriLibCustomView *NakedDriView = [NakedDriLibCustomView creatCustomView];
    NakedDriView.cusType = 1;
    NakedDriView.supNav = self.navigationController;
    NakedDriView.seaDic = self.seaDic;
    [self.view addSubview:NakedDriView];    
    [NakedDriView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.NakedDriV = NakedDriView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
