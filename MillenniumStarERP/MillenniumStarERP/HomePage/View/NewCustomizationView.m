//
//  NewCustomizationView.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2017/12/7.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NewCustomizationView.h"
#import "NewCustomizationCollCell.h"
#import "NewCusBottomView.h"

@interface NewCustomizationView()<UICollectionViewDataSource,UICollectionViewDelegate>{
    int curPage;
    int pageCount;
    int totalCount;//商品总数量
}
@property (strong,nonatomic) UICollectionView *rightCollection;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,assign) BOOL isDef;
@property (nonatomic,strong) NewCustomizationInfo *selInfo;
@end
@implementation NewCustomizationView

#pragma mark -- 创建collectionView

- (id)initWithPop:(BOOL)isDef{
    self = [super init];
    if (self) {
        self.isDef = isDef;
        [self setProTableView];
        [self creatBottomView];
    }
    return self;
}

- (void)setProTableView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0.0f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0.0f;//左右间隔
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//边距距
    self.rightCollection = [[UICollectionView alloc] initWithFrame:CGRectZero
                                              collectionViewLayout:flowLayout];
    self.rightCollection.backgroundColor = [UIColor whiteColor];
    self.rightCollection.delegate = self;
    self.rightCollection.dataSource = self;
    self.rightCollection.scrollsToTop = NO;
    self.rightCollection.bounces = NO;
    self.rightCollection.showsVerticalScrollIndicator = NO;
    self.rightCollection.showsHorizontalScrollIndicator = NO;
    [self addSubview:_rightCollection];
    [_rightCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(-40);
    }];
    //设置当数据小于一屏幕时也能滚动
    self.rightCollection.alwaysBounceVertical = YES;
    UINib *nib = [UINib nibWithNibName:@"NewCustomizationCollCell" bundle:nil];
    [self.rightCollection registerNib:nib
           forCellWithReuseIdentifier:@"NewCustomizationCollCell"];
}

- (void)creatBottomView{
    UIView *bottom = [[UIView alloc]init];
    [self addSubview:bottom];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    if (self.isDef) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [bottom addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottom).offset(0);
            make.left.equalTo(bottom).offset(0);
            make.right.equalTo(bottom).offset(0);
            make.bottom.equalTo(bottom).offset(0);
        }];
    }else{
        NewCusBottomView *bView = [NewCusBottomView creatBottomView];
        bView.back = ^(int idex) {
            if (idex==0) {
                if (self.back) {
                    self.back(NO,@"取消");
                }
            }else{
                if (!self.selInfo) {
                    [MBProgressHUD showError:@"请选择配件"];
                    return;
                }
                if (self.back) {
                    self.back(NO,self.selInfo);
                }
            }
        };
        [bottom addSubview:bView];
        [bView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottom).offset(0);
            make.left.equalTo(bottom).offset(0);
            make.right.equalTo(bottom).offset(0);
            make.bottom.equalTo(bottom).offset(0);
        }];
    }
}

- (void)btnClick:(id)sender{
    if (self.back){
        self.back(YES,@"完成");
    }
}

#pragma mark -- 数据格式
- (void)setDataArr:(NSArray *)dataArr{
    if (dataArr) {
        self.selInfo = nil;
        _dataArr = dataArr;
        _dataArray = _dataArr;
        [self.rightCollection reloadData];
    }
}
#pragma mark--CollectionView-------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewCustomizationCollCell *collcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewCustomizationCollCell" forIndexPath:indexPath];
    if (!self.isDef) {
        collcell.selectedBackgroundView = [[UIView alloc] initWithFrame:collcell.frame];
        collcell.selectedBackgroundView.backgroundColor = [UIColor redColor];
    }
    NewCustomizationInfo *proInfo;
    if (indexPath.row<self.dataArray.count) {
        proInfo = self.dataArray[indexPath.row];
    }
    collcell.info = proInfo;
    collcell.number = [self.dataNum[indexPath.row]intValue];
    return collcell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat width = 0.0;
//    CGFloat height = 0.0;
//    if (self.isH) {
//        width = self.width/2;
//        height = width*0.8;
//    }else{
//        height = self.height/2.0;
//        width = self.width/2.0;
//    }
//    return CGSizeMake(width, height);
    return CGSizeMake(self.width/2.0, (self.height-40)/2.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NewCustomizationInfo *info;
    if (indexPath.row<self.dataArray.count) {
        info = self.dataArray[indexPath.row];
    }
    if (!self.isDef) {
        self.selInfo = info;
    }
    if (self.back&&self.isDef) {
        self.back(YES,@(indexPath.row));
    }
}

@end
