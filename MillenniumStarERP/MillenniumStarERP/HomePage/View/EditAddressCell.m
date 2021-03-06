//
//  EditAddressCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/7.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "EditAddressCell.h"
@interface EditAddressCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@end

@implementation EditAddressCell

+ (EditAddressCell *)cellWithTableView:(UITableView*)tableView{
    static NSString *ID = @"editAddressCell";
    EditAddressCell *userCell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (userCell==nil) {
        userCell = [[EditAddressCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        userCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return userCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"EditAddressCell" owner:nil options:nil][0];
        self.chooseBtn.tag = 0;
        self.editBtn.tag = 1;
        self.deleteBtn.tag = 2;
    }
    return self;
}

- (void)setAddInfo:(AddressInfo *)addInfo{
    if (addInfo) {
        _addInfo = addInfo;
        self.chooseBtn.selected = _addInfo.isDefault;
        self.nameLab.text = [NSString stringWithFormat:@"收货人：%@",_addInfo.name];
        self.addressLab.text = _addInfo.addr;
        self.phoneLab.text = _addInfo.phone;
        self.addressLab.adjustsFontSizeToFitWidth = YES;
    }
}

- (IBAction)btnClick:(UIButton *)sender {
    if (self.didClick) {
        self.didClick(sender.tag);
    }
}

@end
