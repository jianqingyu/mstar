//
//  OrderHeadTableCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/10/8.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "OrderHeadTableCell.h"
#import "FinishedListView.h"
@implementation OrderHeadTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"orderCell";
    OrderHeadTableCell *addCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (addCell==nil) {
        addCell = [[OrderHeadTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return addCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setList:(NSArray *)list{
    if (list) {
        _list = list;
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SDevWidth-20, 18)];
        lab.text = @"参数信息";
        [self.contentView addSubview:lab];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 37, SDevWidth-20, 1)];
        line.backgroundColor = DefaultColor;
        [self.contentView  addSubview:line];
        
        for (int i=0; i<_list.count; i++) {
            int row = i / 2;
            int column = i % 2;
            CGRect frame = CGRectMake(FROWSPACE + FROWWIDTH*column + 10 * column,38+ FROWSPACE + (FROWHEIHT + FROWSPACE)*row, FROWWIDTH, FROWHEIHT);
            FinishedListView *listView = [[FinishedListView alloc]initWithFrame:frame];
            listView.lab1.text = _list[i][@"lab1"];
            listView.lab2.text = _list[i][@"lab2"];
            [self.contentView  addSubview:listView];
        }
    }
}

@end
