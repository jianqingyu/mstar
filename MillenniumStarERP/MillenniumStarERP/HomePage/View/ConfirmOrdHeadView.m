//
//  ConfirmOrdHeadView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ConfirmOrdHeadView.h"
#import "StrWithIntTool.h"
@interface ConfirmOrdHeadView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allBtns;
@property (weak, nonatomic) IBOutlet UIView *baView;
@property (weak, nonatomic) IBOutlet UIScrollView *backScroll;
@end

@implementation ConfirmOrdHeadView

+ (ConfirmOrdHeadView *)view{
    ConfirmOrdHeadView *headView = [[ConfirmOrdHeadView alloc]init];
    return headView;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ConfirmOrdHeadView" owner:nil options:nil][0];
        self.backScroll.contentSize = CGSizeMake(0, 375);
        [self.baView setLayerWithW:3 andColor:BordColor andBackW:0.0001];
        self.noteFie.tag = 7;
        self.wordFie.tag = 6;
        self.customerFie.tag = 5;
        for (int i=0; i<self.allBtns.count; i++) {
            if (i==2||i==3||i==4) {
                UIButton *btn = self.allBtns[i];
                [btn setLayerWithW:3.0 andColor:DefaultColor andBackW:0.001];
            }
        }
    }
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSMutableArray *addArr = @[].mutableCopy;
    if (textField.text.length>0) {
        NSArray *arr = [textField.text componentsSeparatedByString:@" "];
        for (NSString *str in arr) {
            if (![str isEqualToString:@""]) {
                [addArr addObject:str];
            }
        }
        [self.delegate btnClick:self andIndex:textField.tag andMes:[StrWithIntTool strWithArr:addArr]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)setAddInfo:(AddressInfo *)addInfo{
    if (addInfo) {
        _addInfo = addInfo;
        self.nameLab.text = _addInfo.name;
        self.phoneLab.text = _addInfo.phone;
        self.addressLab.text = _addInfo.addr;
    }
}

- (void)setQualityMes:(NSString *)qualityMes{
    if (qualityMes) {
        _qualityMes = qualityMes;
        if (_qualityMes.length>0) {
            [self setupBtn:2 andTitle:_qualityMes];
        }else{
            [self resetBtn:2 andTitle:@"选择质量等级"];
        }
    }
}

- (void)setColorMes:(NSString *)colorMes{
    if (colorMes) {
        _colorMes = colorMes;
        if (_colorMes.length>0) {
            [self setupBtn:3 andTitle:_colorMes];
        }else{
            [self resetBtn:3 andTitle:@"选择成色"];
        }
    }
}

- (void)setInvoMes:(NSString *)invoMes{
    if (invoMes) {
        _invoMes = invoMes;
        if (_invoMes.length>0) {
            [self setupBtn:4 andTitle:_invoMes];
        }else{
            UIButton *btn = self.allBtns[4];
            btn.selected = _invoMes.length;
        }
    }
}

- (void)setupBtn:(int)idx andTitle:(NSString *)str{
    UIButton *btn = self.allBtns[idx];
    if (!btn.selected) {
        btn.selected = YES;
    }
    [btn setTitle:str forState:UIControlStateSelected];
}

- (void)resetBtn:(int)idx andTitle:(NSString *)str{
    UIButton *btn = self.allBtns[idx];
    if (btn.selected) {
        btn.selected = NO;
    }
    [btn setTitle:str forState:UIControlStateNormal];
}

- (void)setOrderInfo:(OrderNewInfo *)orderInfo{
    if (orderInfo) {
        _orderInfo = orderInfo;
        self.customerFie.text = _orderInfo.customerName;
        self.wordFie.text = _orderInfo.word;
        self.noteFie.text = _orderInfo.orderNote;
        [self setupBtn:2 andTitle:_orderInfo.qualityName];
        [self setupBtn:3 andTitle:_orderInfo.purityName];
        if (_orderInfo.invoiceType.length>0) {
            NSString *invoStr = [NSString stringWithFormat:@"类型:%@ 抬头:%@",
                                 _orderInfo.invoiceType,_orderInfo.invoiceTitle];
            [self setupBtn:4 andTitle:invoStr];
        }
    }
}

- (IBAction)headBtnClick:(UIButton *)sender {
    NSInteger index = [self.allBtns indexOfObject:sender];
    [self.wordFie resignFirstResponder];
    [self.customerFie resignFirstResponder];
    [self.delegate btnClick:self andIndex:index andMes:@""];
}

- (IBAction)addBtnClick:(id)sender {
    [self.delegate btnClick:self andIndex:0 andMes:@"添加地址"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.wordFie resignFirstResponder];
    [self.customerFie resignFirstResponder];
}

@end
