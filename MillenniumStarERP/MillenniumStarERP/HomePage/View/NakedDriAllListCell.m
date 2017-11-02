//
//  NakedDriAllListCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriAllListCell.h"
@interface NakedDriAllListCell()
@property (weak, nonatomic) IBOutlet UILabel *orderNLab;
@property (weak, nonatomic) IBOutlet UILabel *staueLab;
@property (weak, nonatomic) IBOutlet UILabel *customerLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *remakeLab;
@property (weak, nonatomic) IBOutlet UIButton *paybtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@end

@implementation NakedDriAllListCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    NakedDriAllListCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[NakedDriAllListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"NakedDriAllListCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setInfo:(NakedDriOListInfo *)info{
    if (info) {
        _info = info;
        NSString *string = _info.orderDate;
        string = [string substringToIndex:10];//截取掉下标10之后的字符串
        self.orderNLab.text = [NSString stringWithFormat:@"订单编号 %@",_info.orderNum];
        self.customerLab.text = [NSString stringWithFormat:@"客户:%@",_info.customerName];
        self.dateLab.text = [NSString stringWithFormat:@"下单时间:%@",string];
        self.remakeLab.text = [NSString stringWithFormat:@"备注:%@",_info.remark];
        self.numLab.text = [NSString stringWithFormat:@"共%@件 合计",_info.number];
        self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",_info.totalPrice];
    }
}

- (void)setStaue:(NSString *)staue{
    if (staue) {
        _staue = staue;
        self.staueLab.text = _staue;
        if ([_staue isEqualToString:@"待付款"]) {
            self.paybtn.hidden = NO;
            self.cancelBtn.hidden = NO;
            [self.paybtn setLayerWithW:3 andColor:MAIN_COLOR andBackW:0.5];
            [self.cancelBtn setLayerWithW:3 andColor:BordColor andBackW:0.5];
        }else{
            self.paybtn.hidden = YES;
            self.cancelBtn.hidden = YES;
        }
    }
}

- (IBAction)payClick:(id)sender {
    if (self.back) {
        self.back(YES);
    }
}

- (IBAction)cancelClick:(id)sender {
    if (self.back) {
        self.back(NO);
    }
}

@end
