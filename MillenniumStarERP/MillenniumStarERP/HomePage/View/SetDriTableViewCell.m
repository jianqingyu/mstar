//
//  SetDriTableViewCell.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/9.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "SetDriTableViewCell.h"
#import "FMDataTool.h"
@interface SetDriTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *minDri;
@property (weak, nonatomic) IBOutlet UILabel *maxDri;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@end
@implementation SetDriTableViewCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    SetDriTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[SetDriTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"SetDriTableViewCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setInfo:(SetDriInfo *)info{
    if (info) {
        _info = info;
        NSArray *arr;
        if ([_info.scope containsString:@"~"]) {
            arr = [_info.scope componentsSeparatedByString:@"~"];
        }
        if (arr.count!=0) {
            self.minDri.text = arr[0];
            self.maxDri.text = arr[1];
        }
        self.numberLab.text = _info.number;
        self.selBtn.selected = [_info.isSel boolValue];
    }
}

- (IBAction)btnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.info.isSel = @(sender.selected);
    [[FMDataTool sharedDataBase]updateDriInfo:self.info];
}

@end
