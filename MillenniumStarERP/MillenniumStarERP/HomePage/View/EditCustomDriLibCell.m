//
//  EditCustomDriLibCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/7/21.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "EditCustomDriLibCell.h"
#import "DetailTypeInfo.h"
#import "CustomShapeBtn.h"
@interface EditCustomDriLibCell()
@property (nonatomic,   weak)UILabel *topLab;
@property (nonatomic, strong)NSMutableArray *mutBtns;
@end
@implementation EditCustomDriLibCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"editBCell";
    EditCustomDriLibCell *imgCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (imgCell==nil) {
        imgCell = [[EditCustomDriLibCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        imgCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return imgCell;
}

- (void)setLibArr:(NSArray *)libArr{
    if (libArr) {
        _libArr = libArr;
    }
    [UIView animateWithDuration:0.1 animations:^{
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
    self.mutBtns = @[].mutableCopy;
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 40, 20)];
    lab.font = [UIFont systemFontOfSize:14];
    CGFloat height = CGRectGetMaxY(lab.frame)+5;
    lab.text = _titleStr;
    [self.contentView addSubview:lab];
    
    CGFloat height2 = CGRectGetMaxX(lab.frame)+2;
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(height2, 5, SDevWidth-height2, 20)];
    lab2.textColor = MAIN_COLOR;
    lab2.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:lab2];
    self.topLab = lab2;
    for (DetailTypeInfo *dInfo in _libArr) {
        if (dInfo.isSel) {
            lab2.text = dInfo.title;
        }
    }
    
    int COLUMN = 5;
    CGFloat ROWSPACE = 10;
    CGFloat rowhei = 25;
    NSInteger total = _libArr.count;
    if (!IsPhone) {
        COLUMN = SDevHeight>SDevWidth?8:10;
    }else{
        COLUMN = SDevHeight>SDevWidth?5:8;
    }
    if (total>2*COLUMN&&self.isSmall) {
        total = 2*COLUMN;
    }
    CGFloat rowWid = (SDevWidth - (COLUMN+1)*10)/COLUMN;
    CGFloat cellHeight = 0;
    
    for (int i=0; i<total; i++) {
        int row = i / COLUMN;
        int column = i % COLUMN;
        DetailTypeInfo *dInfo = _libArr[i];
        CustomShapeBtn *btn = [self creatBtn];
        btn.frame = CGRectMake(ROWSPACE + rowWid*column + ROWSPACE * column,height+ ROWSPACE + (rowhei + ROWSPACE)*row, rowWid, rowhei);
        btn.tag = i;
        [btn setTitle:dInfo.title forState:UIControlStateNormal];
        btn.selected = dInfo.isSel;
        cellHeight = CGRectGetMaxY(btn.frame)+10;
    }
    self.bounds = CGRectMake(0, 0, SDevWidth, cellHeight);
}

- (CustomShapeBtn *)creatBtn{
    CustomShapeBtn *btn = [CustomShapeBtn buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[CommonUtils createImageWithColor:MAIN_COLOR] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(subCateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    [self.mutBtns addObject:btn];
    return btn;
}

- (void)subCateBtnAction:(UIButton *)btn{
    for (DetailTypeInfo *dInfo in _libArr) {
        dInfo.isSel = NO;
    }
    for (int i=0; i<self.mutBtns.count; i++) {
        CustomShapeBtn *sBtn = self.mutBtns[i];
        if (i!=btn.tag) {
            sBtn.selected = NO;
        }
    }
    DetailTypeInfo *info = _libArr[btn.tag];
    btn.selected = !btn.selected;
    info.isSel = btn.selected;
    self.topLab.text = info.isSel?info.title:@"";
}

@end
