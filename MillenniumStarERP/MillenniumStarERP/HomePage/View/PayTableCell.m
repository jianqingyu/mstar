//
//  PayTableCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/10/17.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "PayTableCell.h"

@implementation PayTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"orderTableCell";
    PayTableCell *tableCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (tableCell==nil) {
        tableCell = [[PayTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
//        tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return tableCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"PayTableCell" owner:nil options:nil][0];
    }
    return self;
}

@end
