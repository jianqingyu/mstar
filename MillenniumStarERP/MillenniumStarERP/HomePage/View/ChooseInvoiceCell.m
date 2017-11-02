//
//  ChooseInvoiceCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/12/15.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ChooseInvoiceCell.h"
@interface ChooseInvoiceCell()
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UILabel *invoStrLab;
@end

@implementation ChooseInvoiceCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    ChooseInvoiceCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[ChooseInvoiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
        customCell.chooseBtn.userInteractionEnabled = NO;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ChooseInvoiceCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setDeInfo:(DetailTypeInfo *)deInfo{
    if (deInfo) {
        _deInfo = deInfo;
        self.chooseBtn.selected = _deInfo.isSel;
        self.invoStrLab.text = _deInfo.title;
    }
}

@end
