//
//  UserTodayGoldVC.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/23.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "UserTodayGoldVC.h"
#import "CustomDatePick.h"
#import "UserGoldInfo.h"
#import "UserGoldCollCell.h"
@interface UserTodayGoldVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) CustomDatePick *datePickView;
@property (nonatomic,strong) UICollectionView *rightView;
@property (weak,  nonatomic) IBOutlet UIButton *dateBtn;
@property (weak,  nonatomic) IBOutlet UILabel *lab1;
@property (weak,  nonatomic) IBOutlet UILabel *lab2;
@property (weak,  nonatomic) IBOutlet UILabel *lab3;
@property (nonatomic,  copy) NSString *dateStr;
@property (nonatomic,  copy) NSArray *goldArr;
@end

@implementation UserTodayGoldVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"今日金价";
//    self.view.backgroundColor = DefaultColor;
//    UIImage *image = [UIImage imageNamed:@"gold_bg"];
//    self.view.layer.contents = (id)image.CGImage;
    // 设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    self.dateStr = [formatter stringFromDate:[NSDate date]];
    [self.dateBtn setTitle:self.dateStr forState:UIControlStateNormal];
    [self setCollectionView];
    [self loadDatePick];
    [self loadSearchData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:)
                 name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)orientChange:(NSNotification *)notification{
    [self.rightView reloadData];
}
#pragma mark -- 创建collectionView
- (void)setCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 5.0f;
    flowLayout.minimumInteritemSpacing = 5.0f;//左右间隔
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);//边距距
    self.rightView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                              collectionViewLayout:flowLayout];
    self.rightView.backgroundColor = [UIColor clearColor];
    self.rightView.delegate = self;
    self.rightView.dataSource = self;
    [self.view addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(44);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    //设置当数据小于一屏幕时也能滚动
    self.rightView.alwaysBounceVertical = YES;
    NSString *cellStr = @"UserGoldCollCell";
    UINib *nib = [UINib nibWithNibName:cellStr bundle:nil];
    [self.rightView registerNib:nib forCellWithReuseIdentifier:cellStr];
}

- (void)loadSearchData{
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@GetGoldPrices",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"sdate"] = self.dateStr;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0&&[YQObjectBool boolForObject:response.data]) {
            self.goldArr = [UserGoldInfo mj_objectArrayWithKeyValuesArray:response.data[@"purityGoldPrice"]];
            [self.rightView reloadData];
        }
    } requestURL:regiUrl params:params];
}

#pragma mark--CollectionView-------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.goldArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"UserGoldCollCell";
    UserGoldCollCell *collcell = [collectionView
                   dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    UserGoldInfo *info;
    if (indexPath.row<self.goldArr.count) {
        info = self.goldArr[indexPath.row];
    }
    NSString *str = [NSString stringWithFormat:@"%@  %0.1f/g",info.PurityName,info.UnitPrice];
    collcell.colorLab.text = str;
    return collcell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int num = SDevWidth>SDevHeight?2:1;
    if (!IsPhone) {
        num = SDevWidth>SDevHeight?3:2;
    }
    CGFloat width = (SDevWidth-(num+1)*5)/num;
    return CGSizeMake(width, 44);
}
#pragma mark -- 日历选择
- (void)loadDatePick{
    CustomDatePick *datePick = [CustomDatePick creatCustomView];
    [self.view addSubview:datePick];
    [datePick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    datePick.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
    // 设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    datePick.back = ^(NSDate *date){
        self.dateStr = [formatter stringFromDate:date];
        [self.dateBtn setTitle:self.dateStr forState:UIControlStateNormal];
        [self loadSearchData];
    };
    datePick.hidden = YES;
    self.datePickView = datePick;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.datePickView.hidden = YES;
}

- (IBAction)dateClick:(UIButton *)sender {
    // 设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:self.dateStr];
    [self.datePickView.datePick setDate:date animated:YES];
    self.datePickView.hidden = NO;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
