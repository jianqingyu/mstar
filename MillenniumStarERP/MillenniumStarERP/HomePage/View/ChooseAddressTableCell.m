//
//  ChooseAddressTableCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/10/24.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ChooseAddressTableCell.h"
@interface ChooseAddressTableCell()
@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UIView *editView;
@end
@implementation ChooseAddressTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    ChooseAddressTableCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[ChooseAddressTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ChooseAddressTableCell" owner:nil options:nil][0];
    }
    return self;
}

- (IBAction)editClick:(id)sender {
    if (self.addBack) {
        self.addBack(1);
    }
}

- (IBAction)delectClick:(id)sender {
    if (self.addBack) {
        self.addBack(2);
    }
}

- (void)setUserAddInfo:(AddressInfo *)userAddInfo{
    if (userAddInfo) {
        _userAddInfo = userAddInfo;
        self.selBtn.hidden = !_userAddInfo.isDefault;
        self.nameLab.text = _userAddInfo.name;
        self.addLab.text = _userAddInfo.addr;
        self.phoneLab.text = _userAddInfo.phone;
        if (_userAddInfo.id==0) {
            self.nameLab.backgroundColor = MAIN_COLOR;
            self.nameLab.textColor = [UIColor whiteColor];
            self.editView.hidden = YES;
        }
    }
}

@end
