//
//  NakedDriLibHeadView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriLibHeadView.h"
#import "TTRangeSlider.h"
#import "SearchOrderView.h"
#import "NakedDriLibInfo.h"
#import "SearchDateInfo.h"
@interface NakedDriLibHeadView()<TTRangeSliderDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *topBtns;
//@property (weak, nonatomic) IBOutlet UILabel *sliderLab1;
//@property (weak, nonatomic) IBOutlet UILabel *sliderLab2;
//@property (weak, nonatomic) IBOutlet TTRangeSlider *sliderView1;
//@property (weak, nonatomic) IBOutlet TTRangeSlider *sliderView2;
@property (weak, nonatomic) IBOutlet UIScrollView *driScroll;
@property (weak, nonatomic) IBOutlet UITextField *driFie1;
@property (weak, nonatomic) IBOutlet UITextField *driFie2;
@property (weak, nonatomic) IBOutlet UIScrollView *priceScroll;
@property (weak, nonatomic) IBOutlet UITextField *priceFie1;
@property (weak, nonatomic) IBOutlet UITextField *priceFie2;
@property (nonatomic, copy)NSArray *weightArr;
@property (nonatomic, copy)NSArray *priceArr;
@property (nonatomic,strong)NSMutableArray *mutA;
@property (nonatomic,strong)NSMutableArray *mutB;
@property (nonatomic,strong)NSMutableDictionary *mutDic;
@end
@implementation NakedDriLibHeadView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"NakedDriLibHeadView" owner:nil options:nil][0];
        self.mutDic = @{}.mutableCopy;
        for (UIButton *btn in _topBtns) {
            [btn setLayerWithW:3 andColor:BordColor andBackW:0.5];
            [btn setBackgroundImage:[CommonUtils createImageWithColor:MAIN_COLOR] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        }
        self.driFie1.tag = 1;
        self.driFie2.tag = 2;
        self.priceFie1.tag = 3;
        self.priceFie2.tag = 4;
        self.mutA = [NSMutableArray new];
        self.mutB = [NSMutableArray new];
//        [self setRangeSlider];
    }
    return self;
}

//更新搜索条件
- (void)setSeaDic:(NSDictionary *)seaDic{
    if (seaDic) {
        _seaDic = seaDic;
        NSString *str = _seaDic[@"value"];
        NSArray *arr;
        if ([str containsString:@","]) {
            arr = [str componentsSeparatedByString:@","];
        }
        if (arr.count!=0) {
            self.driFie1.text = arr[0];
            self.driFie2.text = arr[1];
        }
        NSDictionary *dict = _topArr[0];
        self.mutDic[dict[@"keyword"]] = str;
        if (self.back) {
            self.back(self.mutDic);
        }
    }
}

- (void)setInfo:(NakedDriLiblistInfo *)info{
    if (info) {
        _info = info;
        for (int i=0; i<_topBtns.count; i++) {
            NakedDriLibInfo *linfo = info.values[i];
            UIButton *btn = _topBtns[i];
            [btn setTitle:linfo.name forState:UIControlStateNormal];
            btn.selected = linfo.isSel;
        }
    }
}

- (void)setTopArr:(NSArray *)topArr{
    if (topArr) {
        _topArr = topArr;
        if (_topArr.count>1) {
            NSDictionary *dict = _topArr[0];
            _weightArr = [SearchDateInfo objectArrayWithKeyValuesArray:dict[@"list"]];
            [self creatBaseView:_weightArr isYes:YES];
            
            NSDictionary *dict2 = _topArr[1];
            _priceArr = [SearchDateInfo objectArrayWithKeyValuesArray:dict2[@"list"]];
            [self creatBaseView:_priceArr isYes:NO];
        }
    }
}

- (void)creatBaseView:(NSArray *)arr isYes:(BOOL)isFirst{
    CGFloat space = 0;
    CGFloat height = 30;
    CGFloat curX = 0;
    CGFloat width = 0;
    CGFloat vW = 0;
    for (int i=0; i<arr.count; i++) {
        SearchDateInfo *info = arr[i];
        UIButton *btn = [self creatBtn:isFirst];
        UIButton *btnL;
        if (i>0) {
            if (isFirst) {
                btnL = self.mutA[i-1];
            }else{
                btnL = self.mutB[i-1];
            }
            space = 10;
        }
        curX = CGRectGetMaxX(btnL.frame)+space;
        btn.tag = i;
        btn.selected = info.isDefault;
        [btn setTitle:info.title forState:UIControlStateNormal];
        CGRect rect = CGRectMake(0, 0, SDevWidth-30, 999);
        rect = [btn.titleLabel textRectForBounds:rect limitedToNumberOfLines:0];
        width = rect.size.width+10;
        btn.frame = CGRectMake(curX, 15, width, height);
        vW = CGRectGetMaxX(btn.frame)+15;
    }
    if (isFirst) {
        self.driScroll.contentSize = CGSizeMake(vW, 0);
    }else{
        self.priceScroll.contentSize = CGSizeMake(vW, 0);
    }
}

- (UIButton *)creatBtn:(BOOL)isFirst{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[CommonUtils createImageWithColor:DefaultColor]
                   forState:UIControlStateNormal];
    [btn setBackgroundImage:[CommonUtils createImageWithColor:CUSTOM_COLOR(248, 205, 207)] forState:UIControlStateSelected];
    [btn setLayerWithW:5 andColor:BordColor andBackW:0.0001];
    if (isFirst) {
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.driScroll addSubview:btn];
        [self.mutA addObject:btn];
    }else{
        [btn addTarget:self action:@selector(btnPriClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.priceScroll addSubview:btn];
        [self.mutB addObject:btn];
    }
    return btn;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==1||textField.tag==2) {
        for (UIButton *sBtn in self.mutA) {
            sBtn.selected = NO;
        }
        NSDictionary *dic = _topArr[0];
        self.mutDic[dic[@"keyword"]] = [self strWithFie:self.driFie1 and:self.driFie2];
        if (self.back) {
            self.back(self.mutDic);
        }
    }else{
        for (UIButton *sBtn in self.mutB) {
            sBtn.selected = NO;
        }
        NSDictionary *dic = _topArr[1];
        self.mutDic[dic[@"keyword"]] = [self strWithFie:self.priceFie1 and:self.priceFie2];
        if (self.back) {
            self.back(self.mutDic);
        }
    }
}

- (NSString *)strWithFie:(UITextField *)fie1 and:(UITextField *)fie2{
    NSString *str = @"";
    if (fie1.text.length==0) {
        str = [NSString stringWithFormat:@"0,%@",fie2.text];
    }
    if (fie2.text.length==0) {
        str = [NSString stringWithFormat:@"%@,0",fie1.text];
    }
    if (fie1.text.length>0&&fie2.text.length>0) {
        if ([fie1.text floatValue]>[fie2.text floatValue]) {
            fie2.text = @"";
            [MBProgressHUD showError:@"输入有误"];
        }
        str = [NSString stringWithFormat:@"%@,%@",fie1.text,fie2.text];
    }
    return str;
}

- (void)btnClick:(UIButton *)sender{
    for (int i=0; i<self.mutA.count; i++) {
        UIButton *sBtn = self.mutA[i];
        if (i!=(int)sender.tag) {
            sBtn.selected = NO;
        }
    }
    sender.selected = !sender.selected;
    SearchDateInfo *info = _weightArr[sender.tag];
    if (sender.selected) {
        NSArray *arr = [info.key componentsSeparatedByString:@","];
        self.driFie1.text = arr[0];
        BOOL isZero = [arr[1] isEqualToString:@"0"];
        self.driFie2.text = isZero?@"":arr[1];
    }else{
        self.driFie1.text = @"";
        self.driFie2.text = @"";
    }
    NSDictionary *dic = _topArr[0];
    NSString *key = sender.selected?info.key:@"";
    self.mutDic[dic[@"keyword"]] = key;
    if (self.back) {
        self.back(self.mutDic);
    }
}

- (void)btnPriClick:(UIButton *)sender{
    for (int i=0; i<self.mutB.count; i++) {
        UIButton *sBtn = self.mutB[i];
        if (i!=(int)sender.tag) {
            sBtn.selected = NO;
        }
    }
    sender.selected = !sender.selected;
    SearchDateInfo *info = _priceArr[sender.tag];
    if (sender.selected) {
        NSArray *arr = [info.key componentsSeparatedByString:@","];
        self.priceFie1.text = arr[0];
        BOOL isZero = [arr[1] isEqualToString:@"0"];
        self.priceFie2.text = isZero?@"":arr[1];
    }else{
        self.priceFie1.text = @"";
        self.priceFie2.text = @"";
    }
    NSDictionary *dic = _topArr[1];
    NSString *key = sender.selected?info.key:@"";
    self.mutDic[dic[@"keyword"]] = key;
    if (self.back) {
        self.back(self.mutDic);
    }
}

- (void)setAllNoChoose{
    for (UIButton *sBtn in self.mutA) {
        sBtn.selected = NO;
    }
    for (UIButton *sBtn in self.mutB) {
        sBtn.selected = NO;
    }
    for (UIButton *btn in _topBtns) {
        btn.selected = NO;
    }
    self.driFie1.text = @"";
    self.driFie2.text = @"";
    self.priceFie1.text = @"";
    self.priceFie2.text = @"";
    [self.mutDic removeAllObjects];
}

//- (void)setDicArr:(NSArray *)dicArr{
//    if (dicArr) {
//        _dicArr = dicArr;
//        [self setSliderDataView];
//    }
//}

//- (void)setSliderDataView{
//    NSDictionary *dic = _dicArr[0];
//    self.sliderView1.minValue = [dic[@"minimum"]intValue];
//    self.sliderView1.maxValue = [dic[@"maximum"]intValue];
//    self.sliderView1.selectedMinimum = [dic[@"minimum"]intValue];
//    self.sliderView1.selectedMaximum = [dic[@"maximum"]intValue];
//    [self setLabWithRed:self.sliderLab1 and:dic[@"title"] and:@""];
//    
//    NSDictionary *dic1 = _dicArr[1];
//    self.sliderView2.minValue = [dic1[@"minimum"]intValue];
//    self.sliderView2.maxValue = [dic1[@"maximum"]intValue];
//    self.sliderView2.selectedMinimum = [dic1[@"minimum"]intValue];
//    self.sliderView2.selectedMaximum = [dic1[@"maximum"]intValue];
//    [self setLabWithRed:self.sliderLab2 and:dic1[@"title"] and:@""];
//}
//
//- (void)setRangeSlider{
//    self.sliderView1.delegate = self;
//    self.sliderView1.hideLabels = YES;
//    self.sliderView1.handleImage = [UIImage imageNamed:@"icon_20"];
//    self.sliderView1.selectedHandleDiameterMultiplier = 1;
//    self.sliderView1.tintColorBetweenHandles = [UIColor redColor];
//    self.sliderView1.lineHeight = 5;
//    
//    self.sliderView2.delegate = self;
//    self.sliderView2.hideLabels = YES;
//    self.sliderView2.handleImage = [UIImage imageNamed:@"icon_20"];
//    self.sliderView2.selectedHandleDiameterMultiplier = 1;
//    self.sliderView2.tintColorBetweenHandles = [UIColor redColor];
//    self.sliderView2.lineHeight = 5;
//}
//
//#pragma mark TTRangeSliderViewDelegate
//- (void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
//    if (sender == self.sliderView1) {
//        NSString *slider = [NSString stringWithFormat:@"%0.1f ~ %0.1f",selectedMinimum, selectedMaximum];
//        NSString *sDic = [NSString stringWithFormat:@"%0.1f,%0.1f",selectedMinimum, selectedMaximum];
//        NSDictionary *dic = _dicArr[0];
//        [self setLabWithRed:self.sliderLab1 and:dic[@"title"] and:slider];
//        self.mutDic[dic[@"keyword"]] = sDic;
//    }else if (sender == self.sliderView2){
//        NSString *slider = [NSString stringWithFormat:@"%0.0f ~ %0.0f",selectedMinimum, selectedMaximum];
//        NSString *sDic = [NSString stringWithFormat:@"%0.0f,%0.0f",selectedMinimum, selectedMaximum];
//        NSDictionary *dic = _dicArr[1];
//        [self setLabWithRed:self.sliderLab2 and:dic[@"title"] and:slider];
//        self.mutDic[dic[@"keyword"]] = sDic;
//    }
//    if (self.back) {
//        self.back(self.mutDic);
//    }
//}
//
//- (void)setLabWithRed:(UILabel *)lab and:(NSString *)str and:(NSString *)num{
//    NSString *redStr = str;
//    if (num.length>0) {
//        NSArray *b = [str componentsSeparatedByString:@")"];
//        redStr = [NSString stringWithFormat:@"%@) %@",b[0],num];
//    }
//    NSRange range = [str rangeOfString:@")"];
//    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:redStr];
//    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.location+1,redStr.length-range.location-1)];
//    lab.attributedText = attributedStr;
//}

- (IBAction)topBtnClick:(UIButton *)sender {
    NSInteger idex = [self.topBtns indexOfObject:sender];
    NakedDriLibInfo *linfo = _info.values[idex];
    sender.selected = !sender.selected;
    linfo.isSel = sender.selected;
}

@end
