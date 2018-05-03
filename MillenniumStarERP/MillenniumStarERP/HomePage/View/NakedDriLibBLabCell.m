//
//  NakedDriLibBLabCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriLibBLabCell.h"
#import "NakedDriLibInfo.h"
#import "StrWithIntTool.h"
@interface NakedDriLibBLabCell()
@property (nonatomic,  weak)UILabel *topLab;
@end
@implementation NakedDriLibBLabCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"textBCell";
    NakedDriLibBLabCell *imgCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (imgCell==nil) {
        imgCell = [[NakedDriLibBLabCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        imgCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return imgCell;
}

- (void)setTextInfo:(NakedDriLiblistInfo *)textInfo{
    if (textInfo) {
        _textInfo = textInfo;
        [UIView animateWithDuration:0.1 animations:^{
            [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 40, 18)];
        lab.font = [UIFont systemFontOfSize:15];
        CGFloat height = CGRectGetMaxY(lab.frame)+5;
        lab.text = _textInfo.title;
        [self.contentView addSubview:lab];
        
        CGFloat height2 = CGRectGetMaxX(lab.frame)+2;
        UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(height2, 5, SDevWidth-height2, 20)];
        lab2.textColor = MAIN_COLOR;
        lab2.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:lab2];
        self.topLab = lab2;
        NSMutableArray *mutLab = [NSMutableArray new];
        
        int COLUMN = 5;
        if (!IsPhone) {
            COLUMN = SDevHeight>SDevWidth?8:10;
        }else{
            COLUMN = SDevHeight>SDevWidth?5:8;
        }
        CGFloat ROWSPACE = 10;
        NSInteger total = _textInfo.values.count;
        CGFloat rowWid = (SDevWidth - (COLUMN+1)*10)/COLUMN;
        CGFloat rowhei = 25;
        
        CGFloat cellHeight = 0;
        for (int i=0; i<total; i++) {
            int row = i / COLUMN;
            int column = i % COLUMN;
            NakedDriLibInfo *dInfo = _textInfo.values[i];
            UIButton *btn = [self creatBtn];
            btn.frame = CGRectMake(ROWSPACE + rowWid*column + ROWSPACE * column,height+ ROWSPACE + (rowhei + ROWSPACE)*row, rowWid, rowhei);
            btn.tag = i;
            [btn setTitle:dInfo.name forState:UIControlStateNormal];
            btn.selected = dInfo.isSel;
            if (dInfo.isSel) {
                [mutLab addObject:dInfo.name];
            }
            cellHeight = CGRectGetMaxY(btn.frame)+10;
        }
        lab2.text = [StrWithIntTool strWithArr:mutLab With:@","];
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
    NakedDriLibInfo *dInfo = _textInfo.values[btn.tag];
    btn.selected = !btn.selected;
    dInfo.isSel = btn.selected;
    NSMutableArray *arr = [NSMutableArray new];
    for (NakedDriLibInfo *dInfo in _textInfo.values) {
        if (dInfo.isSel) {
            [arr addObject:dInfo.name];
        }
    }
    self.topLab.text = [StrWithIntTool strWithArr:arr With:@","];
}

@end
