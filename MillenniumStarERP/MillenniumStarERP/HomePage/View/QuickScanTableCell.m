//
//  QuickScanTableCell.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/1/31.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "QuickScanTableCell.h"
#import "KeyBoardView.h"
@interface QuickScanTableCell()<UITextFieldDelegate,KeyBoardViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleFie;
@property (weak, nonatomic) IBOutlet UILabel *ptLab;
@property (weak, nonatomic) IBOutlet UIButton *accBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *colourLab;
@property (weak, nonatomic) IBOutlet UITextField *numFie;
@end
@implementation QuickScanTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"cusCell";
    QuickScanTableCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[QuickScanTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"QuickScanTableCell" owner:nil options:nil][0];
        [self setBaseView];
    }
    return self;
}

- (void)setBaseView{
    self.titleFie.tag = 1;
    self.titleFie.delegate = self;
    [self setSearchFieKeyBoard];
    self.titleFie.textColor = ChooseColor;
//    self.colourLab.textColor = ChooseColor;
//    [self.handbtn setTitleColor:ChooseColor forState:UIControlStateSelected];
//    [self.handbtn setTitleColor:ChooseColor forState:UIControlStateNormal];
    self.numFie.tag = 2;
    self.numFie.delegate = self;
    self.numFie.textColor = ChooseColor;
}

- (void)setSearchFieKeyBoard{
    self.titleFie.inputView = nil;
    KeyBoardView * KBView = [[KeyBoardView alloc]init];
    KBView.delegate = self;
    self.titleFie.inputView = KBView;
    KBView.inputSource = self.titleFie;
}

- (void)btnClick:(KeyBoardView *)headView andIndex:(NSInteger)index{
    if (index==201) {
        self.titleFie.inputView = nil;
        [self.titleFie reloadInputViews];
    }else{
        [self.titleFie resignFirstResponder];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField selectAll:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==1&&![textField.text isEqualToString:_modelInfo.title]) {
        if (self.MessBack) {
            self.MessBack(NO,textField.text);
        }
        return;
    }
    if (textField.tag==2) {
        [self backText:[textField.text floatValue]];
        return;
    }
}

- (IBAction)accClick:(id)sender {
    float str = [self.numFie.text floatValue];
    if (str==0.5||str==1) {
        return;
    }
    str--;
    [self backText:str];
}

- (IBAction)addClick:(id)sender {
    float str = [self.numFie.text floatValue];
    str++;
    [self backText:str];
}

- (void)backText:(float)str{
    NSString *string = [NSString stringWithFormat:@"%0.1f",str];
    if (![string isEqualToString:@"0.5"]&&!(fmodf(str, 1)!=0.5)) {
        [MBProgressHUD showError:@"只能填整数或者x.5"];
        self.numFie.text = @"";
    }
    if ([string rangeOfString:@".5"].location != NSNotFound) {
        self.numFie.text = string;
    }else{
        self.numFie.text = [NSString stringWithFormat:@"%0.0f",str];
    }
    if (self.MessBack) {
        self.MessBack(YES,self.numFie.text);
    }
}

- (void)setModelInfo:(DetailModel *)modelInfo{
    if (modelInfo) {
        _modelInfo = modelInfo;
        self.titleFie.text = [NSString stringWithFormat:@"%@",_modelInfo.title];
        self.ptLab.text = _modelInfo.weight;
    }
}

- (void)setMessArr:(NSString *)messArr{
    if (messArr) {
        _messArr = messArr;
        self.numFie.text = _messArr;
    }
}

//- (void)setHandSize:(NSString *)handSize{
//    if (handSize) {
//        _handSize = handSize;
//        if (_handSize.length>0&&![_handSize isEqualToString:@"0"]) {
//            self.handbtn.selected = YES;
//            [self.handbtn setTitle:_handSize forState:UIControlStateSelected];
//        }else{
//            self.handbtn.selected = NO;
//        }
//    }
//}

- (void)setColur:(NSString *)colur{
    if (colur) {
        _colur = colur;
        self.colourLab.text = _colur;
    }
}

- (IBAction)scanClick:(id)sender {
    if (self.MessBack) {
        self.MessBack(NO,@"扫描");
    }
}

@end
