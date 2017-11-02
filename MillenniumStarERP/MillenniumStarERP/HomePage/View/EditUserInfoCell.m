//
//  EditUserInfoCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/28.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "EditUserInfoCell.h"
@interface EditUserInfoCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *showBtn;
@end

@implementation EditUserInfoCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    EditUserInfoCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[EditUserInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"EditUserInfoCell" owner:nil
                                          options:nil][0];
    }
    return self;
}

- (void)setMInfo:(MasterCountInfo *)mInfo{
    if (mInfo) {
        _mInfo = mInfo;
        [self.showBtn setOn:_mInfo.isShowOriginalPrice];
        self.shopFie.text = [NSString stringWithFormat:@"%0.0f",_mInfo.modelAddtion];
        self.driFie.text = [NSString stringWithFormat:@"%0.0f",_mInfo.stoneAddtion];
        self.dri2Fie.text = [NSString stringWithFormat:@"%0.0f",_mInfo.stoneAddtion1];
        self.dri3Fie.text = [NSString stringWithFormat:@"%0.0f",_mInfo.stoneAddtion2];
    }
}

- (IBAction)showPriceClick:(UISwitch *)btn {
    NSString *url = [NSString stringWithFormat:@"%@modifyUserIsShowOriginalPriceDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"isNoShow"] = @(btn.on);
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    _mInfo.isShowOriginalPrice = btn.on;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:@"更新成功"];
        }
    } requestURL:url params:params];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    int str = [textField.text intValue];
    if (str==0) {
        textField.text = @"1";
    }
}

- (IBAction)shopAccClick:(id)sender {
    int str = [self.shopFie.text intValue];
    if (str==1||str<1) {
        return;
    }
    str--;
    self.shopFie.text = [NSString stringWithFormat:@"%d",str];
}

- (IBAction)shopAddClick:(id)sender {
    int str = [self.shopFie.text intValue];
    str++;
    self.shopFie.text = [NSString stringWithFormat:@"%d",str];
}

- (IBAction)driAccClick:(id)sender {
    int str = [self.driFie.text intValue];
    if (str==1||str<1) {
        return;
    }
    str--;
    self.driFie.text = [NSString stringWithFormat:@"%d",str];
}

- (IBAction)driAddClick:(id)sender {
    int str = [self.driFie.text intValue];
    str++;
    self.driFie.text = [NSString stringWithFormat:@"%d",str];
}

- (IBAction)dri2Acc:(id)sender {
    int str = [self.dri2Fie.text intValue];
    if (str==1||str<1) {
        return;
    }
    str--;
    self.dri2Fie.text = [NSString stringWithFormat:@"%d",str];
}

- (IBAction)dri2Add:(id)sender {
    int str = [self.dri2Fie.text intValue];
    str++;
    self.dri2Fie.text = [NSString stringWithFormat:@"%d",str];
}

- (IBAction)dri3Acc:(id)sender {
    int str = [self.dri3Fie.text intValue];
    if (str==1||str<1) {
        return;
    }
    str--;
    self.dri3Fie.text = [NSString stringWithFormat:@"%d",str];
}

- (IBAction)dri3Add:(id)sender {
    int str = [self.dri3Fie.text intValue];
    str++;
    self.dri3Fie.text = [NSString stringWithFormat:@"%d",str];
}

@end
