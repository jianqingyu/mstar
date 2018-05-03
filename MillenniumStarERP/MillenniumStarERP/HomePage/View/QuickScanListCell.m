//
//  QuickScanListCell.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/9.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "QuickScanListCell.h"
#import "CustomShapeBtn.h"
@interface QuickScanListCell()
@property (nonatomic, strong)NSMutableArray *mutBtns;
@end
@implementation QuickScanListCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"listCell";
    QuickScanListCell *imgCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (imgCell==nil) {
        imgCell = [[QuickScanListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        imgCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return imgCell;
}

- (void)setListArr:(NSArray *)listArr{
    if (listArr) {
        _listArr = listArr;
    }
    [UIView animateWithDuration:0.1 animations:^{
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
    self.mutBtns = @[].mutableCopy;
    
    int COLUMN = 3;
    CGFloat ROWSPACE = 5;
    
    CGFloat proportion = IsPhone?0.5:0.65;
    CGFloat allWid = SDevWidth;
    if (SDevWidth>SDevHeight) {
        allWid = proportion*allWid;
    }
    CGFloat rowhei = 28;
    CGFloat rowWid = (allWid - (COLUMN+1)*ROWSPACE)/COLUMN;
    
    CGFloat cellHeight = 0;
    for (int i=0; i<_listArr.count; i++) {
        int row = i / COLUMN;
        int column = i % COLUMN;
        DetailTypeInfo *dInfo = _listArr[i];
        CustomShapeBtn *btn = [self creatBtn];
        btn.frame = CGRectMake(ROWSPACE + rowWid*column + ROWSPACE * column,ROWSPACE + (rowhei + ROWSPACE)*row, rowWid, rowhei);
        btn.tag = i;
        [btn setTitle:dInfo.title forState:UIControlStateNormal];
        btn.selected = dInfo.isSel;
        cellHeight = CGRectGetMaxY(btn.frame)+ROWSPACE;
    }
    self.bounds = CGRectMake(0, 0, allWid, cellHeight);
}

- (CustomShapeBtn *)creatBtn{
    CustomShapeBtn *btn = [CustomShapeBtn buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[CommonUtils createImageWithColor:BordColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(subCateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    [self.mutBtns addObject:btn];
    return btn;
}

- (void)subCateBtnAction:(UIButton *)btn{
    for (DetailTypeInfo *dInfo in _listArr) {
        dInfo.isSel = NO;
    }
    for (int i=0; i<self.mutBtns.count; i++) {
        CustomShapeBtn *sBtn = self.mutBtns[i];
        if (i!=btn.tag) {
            sBtn.selected = NO;
        }
    }
    DetailTypeInfo *info = _listArr[btn.tag];
    btn.selected = !btn.selected;
    info.isSel = btn.selected;
    if (self.back) {
        self.back(info);
    }
}

@end
