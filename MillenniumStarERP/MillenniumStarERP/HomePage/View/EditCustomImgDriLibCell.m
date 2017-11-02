//
//  EditCustomImgDriLibCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/7/26.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "EditCustomImgDriLibCell.h"
#import "DetailTypeInfo.h"
#import <SDWebImage/UIButton+WebCache.h>
@interface EditCustomImgDriLibCell()
@property (nonatomic, strong)NSMutableArray *mutBtns;
@end
@implementation EditCustomImgDriLibCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"editImgCell";
    EditCustomImgDriLibCell *imgCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (imgCell==nil) {
        imgCell = [[EditCustomImgDriLibCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
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
    
    int COLUMN = 5;
    if (!IsPhone) {
        COLUMN = SDevHeight>SDevWidth?8:10;
    }else{
        COLUMN = SDevHeight>SDevWidth?5:8;
    }
    CGFloat ROWSPACE = 10;
    NSInteger total = _libArr.count;
    CGFloat rowWid = (SDevWidth - (COLUMN+1)*10)/COLUMN;
    CGFloat rowhei = rowWid+15;
    CGFloat cellHeight = 0;
    for (int i=0; i<total; i++) {
        int row = i / COLUMN;
        int column = i % COLUMN;
        DetailTypeInfo *dInfo = _libArr[i];
        UIButton *btn = [self creatBtn];
        btn.frame = CGRectMake(ROWSPACE + rowWid*column + ROWSPACE * column,height+ ROWSPACE + (rowhei + ROWSPACE)*row, rowWid, rowhei);
        btn.tag = i;
        btn.selected = dInfo.isSel;
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:dInfo.pic] forState:UIControlStateNormal];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:dInfo.pic1] forState:UIControlStateSelected];
        cellHeight = CGRectGetMaxY(btn.frame)+10;
    }
    self.bounds = CGRectMake(0, 0, SDevWidth, cellHeight);
}

- (UIButton *)creatBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setLayerWithW:5 andColor:BordColor andBackW:0.5];
    [btn addTarget:self action:@selector(subCateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    [self.mutBtns addObject:btn];
    return btn;
}

- (void)subCateBtnAction:(UIButton *)btn{
    for (int i=0; i<self.mutBtns.count; i++) {
        UIButton *sBtn = self.mutBtns[i];
        DetailTypeInfo *dInfo = _libArr[i];
        dInfo.isSel = NO;
        if (i!=btn.tag) {
            sBtn.selected = NO;
        }
    }
    DetailTypeInfo *info = _libArr[btn.tag];
    btn.selected = !btn.selected;
    info.isSel = btn.selected;
}

@end
