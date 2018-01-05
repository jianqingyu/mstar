//
//  NakedDriLibViewController.m
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriLibViewController.h"
#import "NakedDriLibCustomView.h"
#import "NakedDriListOrderVc.h"
@interface NakedDriLibViewController ()
@property (nonatomic,weak)NakedDriLibCustomView *NakedDri;
@end

@implementation NakedDriLibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"裸钻库";
    if (!([[AccountTool account].isNoDriShow intValue]||self.cusType)){
        [self setRightNaviBar];
    }
    [self creatNakedDriView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setSeaDic:(NSDictionary *)seaDic{
    if (seaDic) {
        _seaDic = seaDic;
        if (_NakedDri) {
            _NakedDri.seaDic = _seaDic;
        };
    }
}

- (void)setRightNaviBar{
    UIButton *bar = [UIButton buttonWithType:UIButtonTypeCustom];
    bar.frame = CGRectMake(0, 0, 80, 30);
    [bar setTitle:@"我的订单" forState:UIControlStateNormal];
    bar.titleLabel.font = [UIFont systemFontOfSize:16];
    [bar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bar addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bar];
}

- (void)btnClick:(id)sender{
    NakedDriListOrderVc *listVc = [NakedDriListOrderVc new];
    [self.navigationController pushViewController:listVc animated:YES];
}

- (void)creatNakedDriView{
    NakedDriLibCustomView *NakedDriView = [NakedDriLibCustomView creatCustomView];
    NakedDriView.cusType = self.cusType;
    if (self.seaDic) {
        NakedDriView.seaDic = self.seaDic;
    }
    NakedDriView.supNav = self.navigationController;
    [self.view addSubview:NakedDriView];
    [NakedDriView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.NakedDri = NakedDriView;
}

@end
