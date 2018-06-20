//
//  NewCustomCrossView.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/5/10.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "NewCustomCrossView.h"
#import "NewCustomItemView.h"
#import "NewCustomizationInfo.h"
#import "NewCustomPublicInfo.h"
@interface NewCustomCrossView()
@property (weak,  nonatomic) UIView *backView;
@property (nonatomic,  weak) UIImageView *driImg;
@property (nonatomic,  weak) NewCustomPublicInfo *publicInfo;
@property (nonatomic,strong) NSMutableArray *mutImgs;
@end
@implementation NewCustomCrossView

- (id)init{
    self = [super init];
    if (self) {
        [self createBaseView];
    }
    return self;
}

- (void)setSmallData{
    NewCustomPublicInfo *PInfo = [NewCustomPublicInfo shared];
    self.publicInfo = PInfo;
    NSString *url = PInfo.imgArr[0];
    [self.driImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:DefaultImage];
    for (int i=0; i<PInfo.baseArr.count; i++) {
        NewCustomizationInfo *info = PInfo.baseArr[i];
        NewCustomItemView *item = self.mutImgs[i];
        item.number = [PInfo.numberArr[i]intValue];
        item.info = info;
    }
    if ([self.publicInfo.driData[@"info"]length]>0) {
        [self setDriLabText:self.publicInfo.driData[@"info"]];
    }
    [self setBottomData];
}

- (void)setDriInfo:(id)dic{
    [self.publicInfo changeDriInfo:dic];
    if ([self.publicInfo.driData[@"info"]length]>0) {
        [self setDriLabText:self.publicInfo.driData[@"info"]];
    }
    [self setBottomData];
}

- (void)setBottomData{
    if (self.publicInfo.handSize.length>0) {
        NSString *title = [NSString stringWithFormat:@"手寸 %@",self.publicInfo.handSize];
        UIButton *btn = self.mutImgs[4];
        [btn setTitle:title forState:UIControlStateNormal];
    }
    
    float pri = [self.publicInfo.modelItem[@"price"]floatValue];
    NSDictionary *dic = self.publicInfo.driData;
    float price = pri+[dic[@"price"] floatValue];
    NSString *title = [NSString stringWithFormat:@"￥%0.0f",price];
    UIButton *btn2 = self.mutImgs[5];
    [btn2 setTitle:title  forState:UIControlStateNormal];
}

- (void)setDriLabText:(NSString *)text{
    UILabel *lab = self.mutImgs[3];
    lab.text = text;
    BOOL isChoose = [text isEqualToString:@"选择裸钻"];
    UIColor *color = isChoose?TextlColor:TextBColor;
    lab.textColor = color;
}

- (void)createBaseView{
    self.mutImgs = @[].mutableCopy;
    UIView *baView = [UIView new];
    baView.backgroundColor = [UIColor clearColor];
    [self addSubview:baView];
    [baView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(self.mas_height).multipliedBy(1);
    }];
    self.backView = baView;
    
    UIImageView *logoImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cus_logo"]];
    [baView addSubview:logoImg];
    [logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baView).offset(20);
        make.centerX.mas_equalTo(baView.mas_centerX);
        make.height.mas_equalTo(baView.mas_height).multipliedBy(0.05);
        make.width.mas_equalTo(baView.mas_height).multipliedBy(0.05*392/65);
    }];

    UIView *centerV = [[UIView alloc]init];
    centerV.backgroundColor = [UIColor whiteColor];
    CGFloat minHei = MIN(SDevHeight, SDevWidth);
    CGFloat wid = minHei * 0.5;
    [baView addSubview:centerV];
    [centerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(baView);
        make.height.mas_equalTo(baView.mas_height).multipliedBy(0.5);
        make.width.mas_equalTo(wid);
    }];
    [centerV setLayerWithW:wid/2.0 andColor:BordColor andBackW:0.0001];
    
    CGFloat sWid = wid*0.75;
    UIImageView *ceImage = [[UIImageView alloc]initWithImage:
                            [UIImage imageNamed:@"cus_big.jpg"]];
    [centerV addSubview:ceImage];
    [ceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(centerV);
        make.size.mas_equalTo(CGSizeMake(sWid, sWid));
    }];
    self.driImg = ceImage;
    
    CGFloat itemGar = 100.0/1800*MAX(SDevWidth, SDevHeight);
    CGFloat itemWid = sWid*0.5;
    CGFloat itemHei = itemWid+10;
    
    UIView *itemImg = [UIView new];
    itemImg.backgroundColor = CUSTOM_COLOR(250, 210, 184);
    [baView addSubview:itemImg];
    [itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baView).offset((minHei/2.0-itemHei)/2.0-(1/18.0*itemWid));
        make.right.mas_equalTo(centerV.mas_left).with.offset(-(itemGar+1/20.0*itemWid));
        make.width.mas_equalTo(baView.mas_height).multipliedBy(0.5*0.75*0.5);
        make.height.mas_equalTo(itemHei);
    }];
    
    NewCustomItemView *item = [[NewCustomItemView alloc]init];
    item.back = ^(id model) {
        [self callBack:0 data:YES];
    };
    [baView addSubview:item];
    [item mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baView).offset((minHei/2.0-itemHei)/2.0);
        make.right.mas_equalTo(centerV.mas_left).with.offset(-itemGar);
        make.width.mas_equalTo(itemImg.mas_width).multipliedBy(1);
        make.height.mas_equalTo(itemImg.mas_height).multipliedBy(1);
    }];
    [self.mutImgs addObject:item];
    
    UIView *itemImg2 = [UIView new];
    itemImg2.backgroundColor = CUSTOM_COLOR(250, 210, 184);
    [baView addSubview:itemImg2];
    [itemImg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baView).offset(minHei-(minHei/2.0-itemHei)/2.0-itemHei-(1/20.0*itemWid));
        make.right.mas_equalTo(itemImg.mas_right).with.offset(0);
        make.width.mas_equalTo(itemImg.mas_width).multipliedBy(1);
        make.height.mas_equalTo(itemImg.mas_height).multipliedBy(1);
    }];
    
    NewCustomItemView *item2 = [[NewCustomItemView alloc]init];
    item2.back = ^(id model) {
        [self callBack:1 data:YES];
    };
    [baView addSubview:item2];
    [item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baView).offset(minHei-(minHei/2.0-itemHei)/2.0-itemHei);
        make.right.mas_equalTo(item.mas_right).with.offset(0);
        make.width.mas_equalTo(itemImg.mas_width).multipliedBy(1);
        make.height.mas_equalTo(itemImg.mas_height).multipliedBy(1);
    }];
    [self.mutImgs addObject:item2];
    
    UIView *itemImg3 = [UIView new];
    itemImg3.backgroundColor = CUSTOM_COLOR(250, 210, 184);
    [baView addSubview:itemImg3];
    [itemImg3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(itemImg.mas_top).with.offset(0);
        make.left.mas_equalTo(centerV.mas_right).with.offset((itemGar+1/20.0*itemWid));
        make.width.mas_equalTo(itemImg.mas_width).multipliedBy(1);
        make.height.mas_equalTo(itemImg.mas_height).multipliedBy(1);
    }];
    
    NewCustomItemView *item3 = [[NewCustomItemView alloc]init];
    item3.back = ^(id model) {
        [self callBack:2 data:YES];
    };
    [baView addSubview:item3];
    [item3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(item.mas_top).with.offset(0);
        make.left.mas_equalTo(centerV.mas_right).with.offset(itemGar);
        make.width.mas_equalTo(itemImg.mas_width).multipliedBy(1);
        make.height.mas_equalTo(itemImg.mas_height).multipliedBy(1);
    }];
    [self.mutImgs addObject:item3];
    
    UIView *itemImg4 = [UIView new];
    itemImg4.backgroundColor = CUSTOM_COLOR(250, 210, 184);
    [baView addSubview:itemImg4];
    [itemImg4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(itemImg2.mas_top).with.offset(0);
        make.right.mas_equalTo(itemImg3.mas_right).with.offset(0);
        make.width.mas_equalTo(itemImg.mas_width).multipliedBy(1);
        make.height.mas_equalTo(itemImg.mas_height).multipliedBy(1);
    }];
    
    UIView *item4 = [UIView new];
    item4.backgroundColor = [UIColor whiteColor];
    [self createDriLabWith:item4];
    [baView addSubview:item4];
    [item4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(item2.mas_top).with.offset(0);
        make.right.mas_equalTo(item3.mas_right).with.offset(0);
        make.width.mas_equalTo(itemImg.mas_width).multipliedBy(1);
        make.height.mas_equalTo(itemImg.mas_height).multipliedBy(1);
    }];
    
    UIView *bottomV = [UIView new];
    [self.backView addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(item2.mas_bottom).with.offset(10);
        make.right.mas_equalTo(item4.mas_right).with.offset(0);
        make.left.mas_equalTo(item2.mas_left).with.offset(0);
        make.height.mas_equalTo(60);
    }];
    self.croBtmView = bottomV;
    [self setupBottomBtn:self.croBtmView];
}

- (void)callBack:(int)type data:(BOOL)model{
    if (self.back) {
        self.back(type,model);
    }
}

- (void)driClick:(UIButton *)btn{
    [self callBack:3 data:NO];
}

- (void)createDriLabWith:(UIView *)item4{
    UILabel *dri = [UILabel new];
    dri.textAlignment = NSTextAlignmentCenter;
    dri.text = @"选择裸钻";
    dri.textColor = TextlColor;
    dri.font = [UIFont systemFontOfSize:12];
    dri.numberOfLines = 0;
    dri.adjustsFontSizeToFitWidth = YES;
    [item4 addSubview:dri];
    [dri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(item4).offset(5);
        make.left.equalTo(item4).offset(5);
        make.bottom.equalTo(item4).offset(-5);
        make.right.equalTo(item4).offset(-5);
    }];
    [self.mutImgs addObject:dri];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [item4 addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(item4).offset(0);
        make.left.equalTo(item4).offset(0);
        make.bottom.equalTo(item4).offset(0);
        make.right.equalTo(item4).offset(0);
    }];
    [btn addTarget:self action:@selector(driClick:)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupBottomBtn:(UIView *)baView{
    CGSize bigSize = CGSizeMake(80, 28);
    CGSize btnSize = CGSizeMake(60, 28);
    UIButton *btn1 = [self createBtn:@"手寸" and:5];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baView).offset(0);
        make.left.equalTo(baView).offset(0);
        make.size.mas_equalTo(bigSize);
    }];
    [self.mutImgs addObject:btn1];
    
    UIButton *btn2 = [self createBtn:@"￥0.00" and:10];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn1.mas_top).with.offset(0);
        make.left.mas_equalTo(btn1.mas_right).with.offset(15);
        make.width.mas_equalTo(btn1.mas_width).multipliedBy(1);
        make.height.mas_equalTo(btn1.mas_height).multipliedBy(1);
    }];
    [self.mutImgs addObject:btn2];
    
    UIButton *btn3 = [self createBtn:@"完成" and:6];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn2.mas_top).with.offset(0);
        make.right.equalTo(baView).offset(0);
        make.size.mas_equalTo(btnSize);
    }];
    
    UIButton *btn4 = [self createBtn:@"重置" and:7];
    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn2.mas_top).with.offset(0);
        make.right.mas_equalTo(btn3.mas_left).with.offset(-15);
        make.width.mas_equalTo(btn3.mas_width).multipliedBy(1);
        make.height.mas_equalTo(btn3.mas_height).multipliedBy(1);
    }];
}

- (UIButton *)createBtn:(NSString *)title and:(int)index{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = index;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setLayerWithW:3 andColor:BordColor andBackW:0.001];
    btn.backgroundColor = CUSTOM_COLOR(250, 210, 184);
    [btn addTarget:self action:@selector(botBtnClick:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.croBtmView addSubview:btn];
    return btn;
}

- (void)botBtnClick:(UIButton *)btn{
    [self callBack:(int)btn.tag data:NO];
}

@end
