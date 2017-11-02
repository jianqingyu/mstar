//
//  OrderBottomTableCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/10/8.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "OrderBottomTableCell.h"
@interface OrderBottomTableCell()
@property (weak, nonatomic) IBOutlet UILabel *orderState;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *orderDate;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@end
@implementation OrderBottomTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"orderTableCell";
    OrderBottomTableCell *addCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (addCell==nil) {
        addCell = [[OrderBottomTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return addCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"OrderBottomTableCell" owner:nil options:nil][0];
    }
    return self;
}

@end
