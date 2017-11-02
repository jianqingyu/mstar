//
//  ProductListTableCell.m
//  MillenniumStar
//
//  Created by ❥°澜枫_ on 15/5/19.
//  Copyright (c) 2015年 Millennium Star. All rights reserved.
//

#import "ProductListTableCell.h"
#import "ProductListView.h"
#define perNum 2

@implementation ProductListTableCell

+ (id)cellWithTableView:(UITableView *)tableView andDelegate:(id)delegate with:(BOOL)isShow{
    NSString *cellId = @"mycell";
    ProductListTableCell *pageCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!pageCell) {
        pageCell = [[ProductListTableCell alloc]initWithStyle:UITableViewCellStyleValue1
                                           reuseIdentifier:cellId Delegate:delegate with:isShow];
        pageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        pageCell.backgroundColor = DefaultColor;
    }
    return pageCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Delegate:(id)delegate with:(BOOL)isShow
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        //初始化 添加内容视图
        [self initSubViewWithDelegate:delegate with:isShow];
    }
    return self;
}
//添加视图
- (void)initSubViewWithDelegate:(id)delegate with:(BOOL)isShow
{
    self.devItemArray = [NSMutableArray array];
    for (int i = 0; i < perNum; ++i)
    {
        ProductListView *listView =  [ProductListView shareListView];
        listView.delegate = delegate;
        CGRect itemRect = listView.frame;
        itemRect.size.width = (SDevWidth-(perNum+1)*5)/perNum;
        itemRect.origin.x = i*(itemRect.size.width+5)+5;
        if (isShow) {
            itemRect.size.height = itemRect.size.width+74;
        }else{
            itemRect.size.height = itemRect.size.width+42;
        }
        listView.priceView.hidden = !isShow;
        listView.frame = itemRect;
        [listView.bg setLayerWithW:2 andColor:DefaultColor andBackW:0.5];
        self.bounds = CGRectMake(0, 0, SDevWidth,itemRect.size.height);
        [self.devItemArray addObject:listView];
        [self addSubview:listView];
    }
}
//数据更新
- (void)updateDevInfoWith:(NSMutableArray*)devInfoArray index:(int)index{
    int num = perNum;
    for (int i = index*num; i < num*(index+1); ++i ){
        ProductListView * devInfoItem = nil;
        if ((i - index*num) <= [self.devItemArray count])
        {
            devInfoItem = [self.devItemArray objectAtIndex:(i -index*num)];
        }
        if (i >= [devInfoArray count])
        {
            devInfoItem.hidden = YES;
        }else{
            devInfoItem.hidden = NO;
            //更新某个数据
            [devInfoItem updateDevInfoWith:devInfoArray index:i];
        }
    }
}

@end
