//
//  NakedDriConfirmCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriConfirmCell.h"
@interface NakedDriConfirmCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *deInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UITextField *numFie;
@end
@implementation NakedDriConfirmCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    NakedDriConfirmCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[NakedDriConfirmCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"NakedDriConfirmCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setConInfo:(NakedDriConfirmInfo *)conInfo{
    if (conInfo) {
        _conInfo = conInfo;
        self.deInfoLab.text = _conInfo.info;
        self.priceLab.text = [OrderNumTool strWithPrice:_conInfo.number*_conInfo.price];
        self.numFie.text = [NSString stringWithFormat:@"%d",_conInfo.number];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@"0"]) {
        textField.text = @"1";
    }
    int str = [self.numFie.text intValue];
    [self backText:str];
}

- (IBAction)delClick:(id)sender {
    if (self.back) {
        self.back(YES);
    }
}

- (IBAction)accClick:(id)sender {
    int str = [self.numFie.text intValue];
    if (str==1) {
        return;
    }
    str--;
    [self backText:str];
}

- (IBAction)addClick:(id)sender {
    int str = [self.numFie.text intValue];
    str++;
    [self backText:str];
}

- (void)backText:(int)str{
    self.self.numFie.text = [NSString stringWithFormat:@"%d",str];
    self.conInfo.number = str;
    if (self.back) {
        self.back(NO);
    }
}

@end
