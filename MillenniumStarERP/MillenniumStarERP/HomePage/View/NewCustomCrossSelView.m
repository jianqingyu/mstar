//
//  NewCustomCrossSelView.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/5/14.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "NewCustomCrossSelView.h"
#import "NewCustomizationCollCell.h"
@interface NewCustomCrossSelView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView * rightCollection;
@property (nonatomic,strong)NewCustomizationInfo *selInfo;
@property (nonatomic,  weak)UILabel *titleLab;
@property (nonatomic,  copy)NSArray *dataArray;
@property (nonatomic,assign)CGFloat backH;
@end
@implementation NewCustomCrossSelView

- (id)init{
    self = [super init];
    if (self) {
        self.backH = MIN(SDevHeight, SDevWidth);
        [self createBaseView];
    }
    return self;
}

- (void)createBaseView{
    UIImageView *baImage = [[UIImageView alloc]initWithImage:
                            [UIImage imageNamed:@"list_bg.jpg"]];
    baImage.userInteractionEnabled = YES;
    [self addSubview:baImage];
    [baImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0.15*self.backH);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(1.0*self.backH,0.7*self.backH));
    }];
    [self setTitleTextLab:baImage];
    [self setProTableView:baImage];
    [self setupBottomBtn:baImage];
}

- (void)setStr:(NSString *)str{
    if (str) {
        _str = str;
        self.titleLab.text = _str;
    }
}

- (void)setTitleTextLab:(UIView *)baImage{
    UILabel *dri = [UILabel new];
    dri.textAlignment = NSTextAlignmentCenter;
    dri.text = @"选择裸钻";
    dri.textColor = [UIColor whiteColor];
    dri.font = [UIFont systemFontOfSize:18];
    [self addSubview:dri];
    [dri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.bottom.mas_equalTo(baImage.mas_top).with.offset(-20);
    }];
    self.titleLab = dri;
}

- (void)setupBottomBtn:(UIView *)baView{
    CGSize btnSize = CGSizeMake(60, 28);
    UIButton *btn1 = [self createBtn:@"确定" and:1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(baView.mas_bottom).with.offset(15);
        make.right.mas_equalTo(baView.mas_right).with.offset(0);
        make.size.mas_equalTo(btnSize);
    }];
    
    UIButton *btn2 = [self createBtn:@"清除" and:2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn1.mas_top).with.offset(0);
        make.right.mas_equalTo(btn1.mas_left).with.offset(-15);
        make.size.mas_equalTo(btnSize);
    }];
    
    UIButton *btn3 = [self createBtn:@"取消" and:3];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn2.mas_top).with.offset(0);
        make.right.mas_equalTo(btn2.mas_left).with.offset(-15);
        make.size.mas_equalTo(btnSize);
    }];
}

- (UIButton *)createBtn:(NSString *)title and:(int)index{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = index;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setLayerWithW:3 andColor:BordColor andBackW:0.001];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = CUSTOM_COLOR(250, 210, 184);
    [btn addTarget:self action:@selector(botBtnClick:)
                        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

- (void)botBtnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 1:
            if (!self.selInfo) {
                [MBProgressHUD showError:@"请选择配件"];
                return;
            }
            if (self.back) {
                self.back(YES,self.selInfo);
            }
            break;
        case 2:
            if (self.back) {
                self.back(NO,@"清除");
            }
            break;
        default:
            if (self.back) {
                self.back(NO,@"取消");
            }
            break;
    }
}

- (void)setProTableView:(UIImageView *)backView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 5.0f; //上下间隔
    flowLayout.minimumInteritemSpacing = 5.0f; //左右间隔
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5); //边距距
    self.rightCollection = [[UICollectionView alloc] initWithFrame:CGRectZero
                                              collectionViewLayout:flowLayout];
    self.rightCollection.backgroundColor = [UIColor clearColor];
    self.rightCollection.delegate = self;
    self.rightCollection.dataSource = self;
    self.rightCollection.bounces = NO;
    self.rightCollection.showsVerticalScrollIndicator = NO;
    self.rightCollection.showsHorizontalScrollIndicator = NO;
    [backView addSubview:_rightCollection];
    [_rightCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(0.8*self.backH,0.5*self.backH));
    }];
    //设置当数据小于一屏幕时也能滚动
    self.rightCollection.alwaysBounceVertical = YES;
    NSString *cellId = @"NewCustomizationCollCell";
    UINib *nib = [UINib nibWithNibName:cellId bundle:nil];
    [self.rightCollection registerNib:nib forCellWithReuseIdentifier:cellId];
}
#pragma mark -- 数据格式
- (void)setData:(NSArray *)data{
    if (data) {
        _data = data;
        self.selInfo = nil;
        _dataArray = _data;
        [self.rightCollection reloadData];
    }
}

#pragma mark ------ CollectionView ------
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
    collcell.selectedBackgroundView = [[UIView alloc] initWithFrame:collcell.frame];
    [collcell.selectedBackgroundView setLayerWithW:0.001 andColor:[UIColor blackColor] andBackW:1.5];
    NewCustomizationInfo *proInfo;
    if (indexPath.row<self.dataArray.count) {
        proInfo = self.dataArray[indexPath.row];
    }
    collcell.info = proInfo;
    return collcell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemW = (0.8*self.backH-25)/3.0;
    CGFloat itemH = (0.5*self.backH-15)/2.0;
    return CGSizeMake(itemW,itemH);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NewCustomizationInfo *info;
    if (indexPath.row<self.dataArray.count) {
        info = self.dataArray[indexPath.row];
    }
    self.selInfo = info;
}

@end
