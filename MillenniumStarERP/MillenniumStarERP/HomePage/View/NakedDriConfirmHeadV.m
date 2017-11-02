//
//  NakedDriConfirmHeadV.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/2.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriConfirmHeadV.h"
#import "StrWithIntTool.h"
@interface NakedDriConfirmHeadV()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *addName;
@property (weak, nonatomic) IBOutlet UILabel *addPhone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *invoiceLab;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
@property (weak, nonatomic) IBOutlet UIView *backView;
@end
@implementation NakedDriConfirmHeadV

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"NakedDriConfirmHeadV" owner:nil options:nil][0];
        [self.backView setLayerWithW:3 andColor:BordColor andBackW:0.0001];
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
        [self.delegate btnClick:self andIndex:3 andMes:[StrWithIntTool strWithArr:addArr]];
    }
}

- (void)setAddInfo:(AddressInfo *)addInfo{
    if (addInfo) {
        _addInfo = addInfo;
        self.addName.text = _addInfo.name;
        self.addPhone.text = _addInfo.phone;
        self.address.text = _addInfo.addr;
    }
}

- (void)setInvoMes:(NSString *)invoMes{
    if (invoMes) {
        _invoMes = invoMes;
        if (_invoMes.length>0) {
            self.invoiceLab.text = _invoMes;
        }else{
            self.invoiceLab.text = @"不开发票";
        }
    }
}

- (IBAction)btnClick:(UIButton *)sender {
    NSInteger index = [self.btns indexOfObject:sender];
    [self.delegate btnClick:self andIndex:index andMes:@""];
}

@end
