//
//  QuickScanNoteCell.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/18.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "QuickScanNoteCell.h"
@interface QuickScanNoteCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *noteFie;
@end
@implementation QuickScanNoteCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"noteCell";
    QuickScanNoteCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[QuickScanNoteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"QuickScanNoteCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setNote:(NSString *)note{
    if (note) {
        _note = note;
        self.noteFie.text = _note;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.note = textField.text;
}

@end
