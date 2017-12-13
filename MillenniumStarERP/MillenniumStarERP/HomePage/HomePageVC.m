//
//  HomePageVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/5.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "HomePageVC.h"
#import "UserInfo.h"
#import "HomeHeadView.h"
#import "ProductListVC.h"
#import "EditUserInfoVC.h"
#import "CusTomLoginView.h"
#import "HomePageCollectionCell.h"
#import "NakedDriLibViewController.h"
@interface HomePageVC ()<UINavigationControllerDelegate,UICollectionViewDataSource,
                                   UICollectionViewDelegate>
@property(strong,nonatomic) UICollectionView * rightCollection;
@property(nonatomic,  copy) NSArray *list;
@property(nonatomic,  weak) UIButton *selBtn;
@property(strong,nonatomic) UserInfo *userInfo;
@property(nonatomic,  weak) HomeHeadView *headView;
@property(nonatomic,  copy) NSDictionary *versionDic;
@property(nonatomic,  copy) NSString *openUrl;
@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultColor;
    [self setHeaderView];
    [self setupFootBtn];
    [self loadHomeData];
    self.openUrl = @"https://itunes.apple.com/cn/app/千禧之星珠宝/id1227342902?mt=8";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeHeadImg:) name:NotificationImg object:nil];
}

- (void)changeHeadImg:(NSNotification *)notification{
    NSString *imgUrl = notification.userInfo[UserInfoImg];
    [self.headView.titleImg sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                              placeholderImage:DefaultImage];
}

- (void)orientChange:(NSNotification *)notification{
    BOOL isDev = SDevWidth>SDevHeight;
    CGFloat height = MAX(SDevHeight*0.38, 200);
    if (isDev) {
        [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(180);
        }];
    }else{
        [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    }
    [self.rightCollection reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self removeObserver:self.tabBarController forKeyPath:@"tabCount"];
//}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)setHeaderView{
    CGFloat height = MAX(SDevHeight*0.38, 200);
    HomeHeadView *headView = [HomeHeadView view];
    [self.view addSubview:headView];
    self.headView = headView;
    [headView.setBtn addTarget:self action:@selector(setClick:)
                                forControlEvents:UIControlEventTouchUpInside];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(height);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 5.0f;//左右间隔
    flowLayout.minimumLineSpacing = 5.0f;//上下间隔
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);//边距距
    self.rightCollection = [[UICollectionView alloc] initWithFrame:CGRectZero
                                              collectionViewLayout:flowLayout];
    self.rightCollection.backgroundColor = DefaultColor;
    self.rightCollection.delegate = self;
    self.rightCollection.dataSource = self;
    [self.view addSubview:_rightCollection];
    [_rightCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    //设置当数据小于一屏幕时也能滚动
    self.rightCollection.alwaysBounceVertical = YES;
    UINib *nib = [UINib nibWithNibName:@"HomePageCollectionCell" bundle:nil];
    [self.rightCollection registerNib:nib
                 forCellWithReuseIdentifier:@"HomePageCollectionCell"];
}

- (void)setupFootBtn{
    UIButton *footBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    footBtn.backgroundColor = DefaultColor;
    [footBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [footBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    [footBtn addTarget:self action:@selector(btnClick)
                                  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footBtn];
    [footBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).with.offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    self.selBtn = footBtn;
}

- (void)btnClick{
    [self loadHomeData];
}

- (void)loadHomeData{
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@userAdminPage",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"userInfo"]]) {
                self.selBtn.hidden = YES;
                self.userInfo = [UserInfo objectWithKeyValues:response.data[@"userInfo"]];
                self.headView.userInfo = self.userInfo;
                self.tabCount = self.userInfo.mesCount;
            }
            if ([YQObjectBool boolForObject:response.data[@"functionsList"]]) {
                NSArray *arr = response.data[@"functionsList"];
                self.list = arr;
                [self.rightCollection reloadData];
            }
        }else{
            [MBProgressHUD showError:response.message];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

#pragma mark--CollectionView-------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.list.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SDevWidth-5*5)/4, 80);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageCollectionCell *collcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageCollectionCell" forIndexPath:indexPath];
    [collcell setLayerWithW:0.1 andColor:BordColor andBackW:0.1];
    NSDictionary *dict = self.list[indexPath.row];
    [collcell.image sd_setImageWithURL:dict[@"pic"] placeholderImage:DefaultImage];
    collcell.title.text = dict[@"title"];
    [collcell.title setAdjustsFontSizeToFitWidth:YES];
    return collcell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            ProductListVC*listVc = [[ProductListVC alloc]init];
            [self.navigationController pushViewController:listVc animated:YES];
        }
            break;
        case 1:{
            NakedDriLibViewController*listVc = [[NakedDriLibViewController alloc]init];
            [self.navigationController pushViewController:listVc animated:YES];
        }
        default:
            break;
    }
}

- (void)setClick:(id)sender{
    EditUserInfoVC *infoVc = [[EditUserInfoVC alloc]init];
    [self.navigationController pushViewController:infoVc animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
