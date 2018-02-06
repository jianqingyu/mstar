//
//  CustomDriWordCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/8/8.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "CustomDriWordCell.h"
@interface CustomDriWordCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *wordFie;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;
@end
@implementation CustomDriWordCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"driCell";
    CustomDriWordCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[CustomDriWordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CustomDriWordCell" owner:nil options:nil][0];
        self.wordFie.textColor = ChooseColor;
    }
    return self;
}

- (void)setCate:(NSString *)cate{
    if (cate) {
        _cate = cate;
        BOOL isShow = [_cate containsString:@"戒"];
        self.lookBtn.hidden = !isShow;
    }
}

- (void)setWord:(NSString *)word{
    if (word) {
        _word = word;
        self.wordFie.text = _word;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self resetText:textField];
}

- (IBAction)textClick:(UIButton *)sender {
    NSInteger idx = [self.btns indexOfObject:sender];
    if (idx==0) {
        self.wordFie.text = [NSString stringWithFormat:@"%@❤️",self.wordFie.text];
    }else{
        self.wordFie.text = [NSString stringWithFormat:@"%@&",self.wordFie.text];
    }
    [self resetText:self.wordFie];
}

- (void)resetText:(UITextField *)fie{
    BOOL isHave = [fie.text containsString:@"❤️"];
    int count = isHave?6:5;
    //如果输入框中的文字大于5，就截取前5个作为输入框的文字
    if (fie.text.length > count) {
        fie.text = [fie.text substringToIndex:count];
    }
    if (self.back) {
        self.back(YES,fie.text);
    }
}

- (IBAction)lookWord:(id)sender {
    [self.wordFie resignFirstResponder];
    if (self.back) {
        self.back(NO,@"");
    }
}

@end
