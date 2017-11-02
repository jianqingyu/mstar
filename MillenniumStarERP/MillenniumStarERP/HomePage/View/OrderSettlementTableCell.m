//
//  OrderSettlementTableCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/6.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "OrderSettlementTableCell.h"
@interface OrderSettlementTableCell()
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *customLab;
@property (weak, nonatomic) IBOutlet UILabel *orderDate;
@property (weak, nonatomic) IBOutlet UILabel *colorLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *deNumLab;
@property (weak, nonatomic) IBOutlet UILabel *setNumLab;
@property (weak, nonatomic) IBOutlet UILabel *lookSetNum;
@end
@implementation OrderSettlementTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"orderListCell";
    OrderSettlementTableCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[OrderSettlementTableCell alloc]initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"OrderSettlementTableCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setListInfo:(OrderListNewInfo *)listInfo{
    if (listInfo) {
        _listInfo = listInfo;
        NSString *string = _listInfo.orderDate;
        string = [string substringToIndex:10];//截取掉下标10之后的字符串
        self.orderNum.text = _listInfo.orderNum;
        self.customLab.text = _listInfo.customerName;
        self.orderDate.text = string;
        self.colorLab.text = _listInfo.purityName;
        self.numLab.text = [NSString stringWithFormat:@"%@件",_listInfo.number];
        self.deNumLab.text = [NSString stringWithFormat:@"%@件",_listInfo.moNum];
        self.setNumLab.text = [NSString stringWithFormat:@"%@件",_listInfo.recNum];
        self.lookSetNum.text = [NSString stringWithFormat:@"查看结算单(%@)",_listInfo.recBillNum];
    }
}

@end
