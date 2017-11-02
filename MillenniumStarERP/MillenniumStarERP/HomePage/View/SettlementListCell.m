//
//  SettlementListCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/7.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SettlementListCell.h"
@interface SettlementListCell()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *delNum;
@property (weak, nonatomic) IBOutlet UILabel *setDate;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@end
@implementation SettlementListCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    SettlementListCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[SettlementListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"SettlementListCell" owner:nil options:nil][0];
        self.backView.backgroundColor = CUSTOM_COLOR(245, 245, 247);
        self.backView.layer.cornerRadius = 5;;
        self.backView.layer.borderWidth = 1;
        self.backView.layer.borderColor = DefaultColor.CGColor;
        self.backView.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setListInfo:(DelSListInfo *)listInfo{
    if (listInfo) {
        _listInfo = listInfo;
        NSString *string = _listInfo.moDate;
        string = [string substringToIndex:10];//截取掉下标10之后的字符串
        self.delNum.text = [NSString stringWithFormat:@"出库单号 %@",_listInfo.moNum];
        self.setDate.text = [NSString stringWithFormat:@"出货日期 : %@",string];
        NSString *dePrice = [OrderNumTool strWithPrice:_listInfo.totalPrice];
        self.priceLab.text = [NSString stringWithFormat:@"价格 : %@",dePrice];
        self.priceLab.hidden = !self.isShow;
        self.numLab.text = [NSString stringWithFormat:@"数量 : %@件",_listInfo.number];
    }
}

@end
