//
//  MyOrderListCell.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/5/10.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "MyOrderListCell.h"
@interface MyOrderListCell()
@property (weak, nonatomic) IBOutlet UILabel *customter;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *allCountLab;
@end
@implementation MyOrderListCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    MyOrderListCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[MyOrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"MyOrderListCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setInfo:(UserCustomerInfo *)info{
    if (info) {
        _info = info;
        self.customter.text = _info.customerName;
        self.numLab.text = [NSString stringWithFormat:@"%@单",_info.count];
        self.allCountLab.text = [NSString stringWithFormat:@"%@件",_info.count];
        NSString *string = _info.orderDate;
        string = [string substringToIndex:10];  //截取掉下标10之后的字符串
        self.dateLab.text = string;
    }
}

@end
