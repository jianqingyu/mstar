//
//  NakedDriLibSLabCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriLibSLabCell.h"
#import "nakedDriLibInfo.h"
@implementation NakedDriLibSLabCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"textSCell";
    NakedDriLibSLabCell *imgCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (imgCell==nil) {
        imgCell = [[NakedDriLibSLabCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        imgCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return imgCell;
}

- (void)setTextSInfo:(NakedDriLiblistInfo *)textSInfo{
    if (textSInfo) {
        _textSInfo = textSInfo;
        [UIView animateWithDuration:0.1 animations:^{
            [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 40, 18)];
        lab.font = [UIFont systemFontOfSize:15];
        CGFloat labWid = CGRectGetMaxX(lab.frame)+5;
        lab.text = _textSInfo.title;
        [self.contentView addSubview:lab];
        
        int COLUMN = 5;
        if (!IsPhone) {
            COLUMN = SDevHeight>SDevWidth?8:10;
        }else{
            COLUMN = SDevHeight>SDevWidth?5:8;
        }
        CGFloat ROWSPACE = 10;
        NSInteger total = _textSInfo.values.count;
        CGFloat rowWid = (SDevWidth-labWid-(COLUMN+1)*10)/COLUMN;
        CGFloat rowhei = 25;
        
        CGFloat cellHeight = 0;
        for (int i=0; i<total; i++) {
            int row = i / COLUMN;
            int column = i % COLUMN;
            NakedDriLibInfo *dInfo = _textSInfo.values[i];
            UIButton *btn = [self creatBtn];
            btn.frame = CGRectMake(labWid+ ROWSPACE + rowWid*column + ROWSPACE * column,ROWSPACE + (rowhei + ROWSPACE)*row, rowWid, rowhei);
            btn.tag = i;
            btn.selected = dInfo.isSel;
            [btn setTitle:dInfo.name forState:UIControlStateNormal];
            cellHeight = CGRectGetMaxY(btn.frame)+10;
        }
        self.bounds = CGRectMake(0, 0, SDevWidth, cellHeight);
    }
}

- (UIButton *)creatBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[CommonUtils createImageWithColor:MAIN_COLOR] forState:UIControlStateSelected];
    [btn setLayerWithW:5 andColor:BordColor andBackW:0.5];
    [btn addTarget:self action:@selector(subCateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    return btn;
}

- (void)subCateBtnAction:(UIButton *)btn{
    NakedDriLibInfo *dInfo = _textSInfo.values[btn.tag];
    btn.selected = !btn.selected;
    dInfo.isSel = btn.selected;
}

@end
