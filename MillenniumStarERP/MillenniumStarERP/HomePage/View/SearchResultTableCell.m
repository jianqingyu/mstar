//
//  SearchResultTableCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/16.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SearchResultTableCell.h"
@interface SearchResultTableCell()
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *customer;
@property (weak, nonatomic) IBOutlet UILabel *orderDate;
@property (weak, nonatomic) IBOutlet UILabel *pureyLab;
@property (weak, nonatomic) IBOutlet UILabel *goldLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@end

@implementation SearchResultTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    SearchResultTableCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[SearchResultTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"SearchResultTableCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setInfo:(SearchResultInfo *)info{
    if (info) {
        _info = info;
        self.orderNum.text = _info.orderNum;
        NSString *string = _info.orderDate;
        string = [string substringToIndex:10];//截取掉下标10之后的字符串
        self.orderDate.text = string;
        self.pureyLab.text = _info.purityName;
        self.customer.text = _info.customerName;
        
        self.goldLab.text = [OrderNumTool strWithPrice:_info.goldPrice];
        self.numLab.text = [NSString stringWithFormat:@"%@件",_info.number];
    }
}

@end
