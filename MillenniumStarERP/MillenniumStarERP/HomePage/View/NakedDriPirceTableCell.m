//
//  NakedDriPirceTableCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriPirceTableCell.h"
@interface NakedDriPirceTableCell()
@property (weak, nonatomic) IBOutlet UILabel *staueLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UIButton *copBtn;
@end
@implementation NakedDriPirceTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    NakedDriPirceTableCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[NakedDriPirceTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"NakedDriPirceTableCell" owner:nil options:nil][0];
        [self.copBtn setLayerWithW:3 andColor:BordColor andBackW:0.0001];
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic{
    if (dataDic) {
        _dataDic = dataDic;
        self.staueLab.text = _dataDic[@"title"];
        self.infoLab.text = _dataDic[@"content"];
    }
}

- (IBAction)copyClick:(id)sender {
    [MBProgressHUD showSuccess:@"复制成功!"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _dataDic[@"content"];
}

@end
