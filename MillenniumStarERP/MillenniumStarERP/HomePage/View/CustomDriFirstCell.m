//
//  CustomDriFirstCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/8/8.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "CustomDriFirstCell.h"
@interface CustomDriFirstCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *ptLab;
@property (weak, nonatomic) IBOutlet UIButton *accBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@end
@implementation CustomDriFirstCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"driFirstCell";
    CustomDriFirstCell *addCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (addCell==nil) {
        addCell = [[CustomDriFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return addCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CustomDriFirstCell" owner:nil options:nil][0];
        self.fie1.delegate = self;
        self.accBtn.enabled = NO;
        self.addBtn.enabled = NO;
        self.fie1.userInteractionEnabled = NO;
    }
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self backText:[textField.text floatValue]];
}

- (IBAction)accClick:(id)sender {
    float str = [self.fie1.text floatValue];
    if (str==0.5||str==1) {
        return;
    }
    str--;
    [self backText:str];
}

- (IBAction)addClick:(id)sender {
    float str = [self.fie1.text floatValue];
    str++;
    [self backText:str];
}

- (void)backText:(float)str{
    NSString *string = [NSString stringWithFormat:@"%0.1f",str];
    if (![string isEqualToString:@"0.5"]&&!(fmodf(str, 1)!=0.5)) {
        [MBProgressHUD showError:@"只能填整数或者x.5"];
        self.fie1.text = @"";
    }
    if ([string rangeOfString:@".5"].location != NSNotFound) {
        self.fie1.text = string;
    }else{
        self.fie1.text = [NSString stringWithFormat:@"%0.0f",str];
    }
    if (self.MessBack) {
        self.MessBack(YES,self.fie1.text);
    }
}

- (IBAction)handClick:(id)sender {
    if (self.MessBack) {
        self.MessBack(NO,@"");
    }
}

//- (void)setCertCode:(NSString *)certCode{
//    if (certCode) {
//        _certCode = certCode;
//        self.accBtn.enabled = !_certCode.length;
//        self.addBtn.enabled = !_certCode.length;
//        self.fie1.userInteractionEnabled = !_certCode.length;
//    }
//}

- (void)setModelInfo:(DetailModel *)modelInfo{
    if (modelInfo) {
        _modelInfo = modelInfo;
        self.titleLab.text = [NSString stringWithFormat:@"%@ %@",_modelInfo.title,_modelInfo.categoryTitle];
        self.ptLab.text = _modelInfo.weight;
    }
}

- (void)setMessArr:(NSString *)messArr{
    if (messArr) {
        _messArr = messArr;
        self.fie1.text = _messArr;
    }
}

- (void)setHandSize:(NSString *)handSize{
    if (handSize) {
        _handSize = handSize;
        if (_handSize.length>0&&![_handSize isEqualToString:@"0"]) {
            self.handbtn.selected = YES;
            [self.handbtn setTitle:_handSize forState:UIControlStateSelected];
        }else{
            self.handbtn.selected = NO;
        }
    }
}

- (void)setColur:(NSString *)colur{
    if (colur) {
        _colur = colur;
        self.colourLab.text = _colur;
    }
}

- (IBAction)colourClick:(id)sender {
    if (self.MessBack) {
        self.MessBack(YES,@"成色");
    }
}

@end
