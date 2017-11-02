//
//  FinishedFootView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/26.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "FinishedFootView.h"
#import "FinishedListView.h"
@implementation FinishedFootView

- (void)setList:(NSArray *)list{
    if (list) {
        _list = list;
        self.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SDevWidth-20, 18)];
        lab.text = @"基本信息";
        [self addSubview:lab];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 37, SDevWidth-20, 1)];
        line.backgroundColor = DefaultColor;
        [self addSubview:line];
        
        for (int i=0; i<_list.count; i++) {
            int row = i / 2;
            int column = i % 2;
            CGRect frame = CGRectMake(FROWSPACE + FROWWIDTH*column + 10 * column,38+ FROWSPACE + (FROWHEIHT + FROWSPACE)*row, FROWWIDTH, FROWHEIHT);
            FinishedListView *listView = [[FinishedListView alloc]initWithFrame:frame];
            listView.lab1.text = _list[i][@"lab1"];
            listView.lab2.text = _list[i][@"lab2"];
            [self addSubview:listView];
        }
    }
}

@end
