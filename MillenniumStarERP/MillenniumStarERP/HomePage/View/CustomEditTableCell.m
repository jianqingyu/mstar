//
//  CustomEditTableCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/7/17.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "CustomEditTableCell.h"

@implementation CustomEditTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customEditCell";
    CustomEditTableCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[CustomEditTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CustomEditTableCell" owner:nil options:nil][0];
    }
    return self;
}

- (IBAction)resetClick:(id)sender {
    if (self.back) {
        self.back(@1);
    }
}

- (IBAction)deleClick:(id)sender {
    if (self.back) {
        self.back(@2);
    }
}

- (IBAction)addClick:(id)sender {
    if (self.back) {
        self.back(@3);
    }
}

@end
