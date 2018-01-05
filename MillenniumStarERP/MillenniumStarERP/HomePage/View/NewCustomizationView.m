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
@property (nonatomic,strong) NSMutableArray *btnArr;
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
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0.5f;
    flowLayout.minimumInteritemSpacing = 0.0f;//左右间隔
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//边距距
    self.rightCollection = [[UICollectionView alloc] initWithFrame:CGRectZero
                                              collectionViewLayout:flowLayout];
    self.rightCollection.backgroundColor = DefaultColor;
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
        make.height.mas_equalTo(_rightCollection.mas_width).multipliedBy(0.8);
    }];
    //设置当数据小于一屏幕时也能滚动
    self.rightCollection.alwaysBounceVertical = YES;
    UINib *nib = [UINib nibWithNibName:@"NewCustomizationCollCell" bundle:nil];
    [self.rightCollection registerNib:nib
           forCellWithReuseIdentifier:@"NewCustomizationCollCell"];
}

- (void)creatBottomView{
    UIView *bottom = [[UIView alloc]init];
    [bottom setLayerWithW:0.0001 andColor:LineColor andBackW:0.5];
    [self addSubview:bottom];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    if (self.isDef) {
        self.btnArr = @[].mutableCopy;
        UIButton *btn2 = [self creatNormalBtn:DefaultColor andTi:@"重置" and:1];
        [bottom addSubview:btn2];
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottom).offset(0);
            make.left.equalTo(bottom).offset(0);
            make.width.mas_equalTo(bottom .mas_width).multipliedBy(0.5);
            make.bottom.equalTo(bottom).offset(0);
        }];
        UIButton *btn1 = [self creatNormalBtn:[UIColor whiteColor] andTi:@"完成" and:0];
        [bottom addSubview:btn1];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottom).offset(0);
            make.right.equalTo(bottom).offset(0);
            make.width.mas_equalTo(bottom .mas_width).multipliedBy(0.5);
            make.bottom.equalTo(bottom).offset(0);
        }];
        self.btn = btn1;
    }else{
        NewCusBottomView *bView = [NewCusBottomView creatBottomView];
        bView.back = ^(int idex) {
            if (idex==0) {
                if (self.back) {
                    self.back(NO,@"取消");
                }
            }else if (idex==1) {
                if (self.back) {
                    self.back(NO,@"删除");
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

- (UIButton *)creatNormalBtn:(UIColor *)color andTi:(NSString *)title and:(int)tag{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.tag = tag;
    btn.backgroundColor = color;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [self.btnArr addObject:btn];
    return btn;
}

- (void)btnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
            if (self.back){
                self.back(YES,@"完成");
            }
            break;
        case 1:
            if (self.back){
                self.back(YES,@"重置");
            }
            break;
        default:
            break;
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

- (void)setDrillInfo:(NSString *)drillInfo{
    if (drillInfo) {
        _drillInfo = drillInfo;
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
    return self.isDef?self.dataArray.count+1:self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewCustomizationCollCell *collcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewCustomizationCollCell" forIndexPath:indexPath];
    if (!self.isDef) {
        collcell.selectedBackgroundView = [[UIView alloc] initWithFrame:collcell.frame];
        [collcell.selectedBackgroundView setLayerWithW:0.001 andColor:[UIColor blackColor] andBackW:1.5];
    }else{
        if (indexPath.row==self.dataArray.count) {
            collcell.drillStr = self.drillInfo;
            return collcell;
        }
    }
    collcell.isDef = self.isDef;
    collcell.number = [self.dataNum[indexPath.row]intValue];
    NewCustomizationInfo *proInfo;
    if (indexPath.row<self.dataArray.count) {
        proInfo = self.dataArray[indexPath.row];
    }
    collcell.info = proInfo;
    return collcell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat wid = self.width*0.5;
    return CGSizeMake(wid,(int)wid*0.8);
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
        if (indexPath.row==self.dataArray.count) {
            self.back(YES,@"选择裸钻");
        }else{
            self.back(YES,@(indexPath.row));
            
        }
    }
}

@end
