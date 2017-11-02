//
//  NakedDriOrderDetailCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriOrderDetailCell.h"
@interface NakedDriOrderDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *detailInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@end
@implementation NakedDriOrderDetailCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    NakedDriOrderDetailCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[NakedDriOrderDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"NakedDriOrderDetailCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setLInfo:(NakedDriDetailLInfo *)lInfo{
    if (lInfo) {
        _lInfo = lInfo;
        self.detailInfoLab.text = _lInfo.info;
        
        self.priceLab.text = [OrderNumTool strWithPrice:_lInfo.price];
        self.numLab.text = [NSString stringWithFormat:@"x%@",_lInfo.number];
    }
}

@end
