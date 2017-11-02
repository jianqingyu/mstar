//
//  EditCustomDriTableCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/7/21.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "EditCustomDriTableCell.h"
@interface EditCustomDriTableCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *weightFie;
@property (weak, nonatomic) IBOutlet UITextField *numfie;
@end
@implementation EditCustomDriTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"EditDriCell";
    EditCustomDriTableCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[EditCustomDriTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"EditCustomDriTableCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    BOOL isW = [textField.text containsString:@"."];
    [self backText:[textField.text floatValue] isWei:isW andFie:textField];
    self.number = self.numfie.text;
    self.weight = self.weightFie.text;
    [self chooseBack];
}

- (void)setNumber:(NSString *)number{
    if (number) {
        _number = number;
    }
    self.numfie.text = _number;
}

- (void)setWeight:(NSString *)weight{
    if (weight) {
        _weight = weight;
    }
    self.weightFie.text = _weight;
}

- (IBAction)accWeiClick:(id)sender {
    float str = [self.weightFie.text floatValue];
    if (str<0.1||str==0.1) {
        return;
    }
    str = str-0.1;
    [self backText:str isWei:YES andFie:self.weightFie];
    self.weight = self.weightFie.text;
    [self chooseBack];
}

- (IBAction)addWeiClick:(id)sender {
    float str = [self.weightFie.text floatValue];
    str = str+0.1;
    [self backText:str isWei:YES andFie:self.weightFie];
    self.weight = self.weightFie.text;
    [self chooseBack];
}

- (void)backText:(float)str isWei:(BOOL)isYes andFie:(UITextField *)fie{
    NSString *string;
    if (isYes) {
        string = [NSString stringWithFormat:@"%0.2f",str];
    }else{
        string = [NSString stringWithFormat:@"%0.0f",str];
    }
    if ([string isEqualToString:@"0.00"]) {
        string = @"0.1";
    }
    if ([string isEqualToString:@"0"]) {
        string = @"1";
    }
    fie.text = string;
}

- (IBAction)accNumClick:(id)sender {
    float str = [self.numfie.text floatValue];
    if (str==1||str<1) {
        return;
    }
    str--;
    [self backText:str isWei:NO andFie:self.numfie];
    self.number = self.numfie.text;
    [self chooseBack];
}

- (IBAction)addNumClick:(id)sender {
    float str = [self.numfie.text floatValue];
    str++;
    [self backText:str isWei:NO andFie:self.numfie];
    self.number = self.numfie.text;
    [self chooseBack];
}

- (void)chooseBack{
    if (self.fieBack) {
        self.fieBack(@[self.weight,self.number]);
    }
}

@end
