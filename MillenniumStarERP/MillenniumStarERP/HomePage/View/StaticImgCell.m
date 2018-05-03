//
//  StaticImgCell.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/11.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "StaticImgCell.h"
#import "StaticImgInfo.h"
#import <SDWebImage/UIButton+WebCache.h>
@implementation StaticImgCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"imgCell";
    StaticImgCell *imgCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (imgCell==nil) {
        imgCell = [[StaticImgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        imgCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return imgCell;
}

- (void)setNumInfo:(StaticNumInfo *)numInfo{
    if (numInfo) {
        _numInfo = numInfo;
        [UIView animateWithDuration:0.1 animations:^{
            [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 18)];
        lab.font = [UIFont systemFontOfSize:15];
        CGFloat height = CGRectGetMaxY(lab.frame)+5;
        NSString *text = [NSString stringWithFormat:@"%@  %@件",_numInfo.rangeTitle,_numInfo.count];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        [str addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(text.length-2,1)];
        lab.attributedText = str;
        [self.contentView addSubview:lab];

        int COLUMN = 5;
        if (!IsPhone) {
            COLUMN = SDevHeight>SDevWidth?8:10;
        }else{
            COLUMN = SDevHeight>SDevWidth?5:8;
        }
        CGFloat ROWSPACE = 5;
        NSInteger total = _numInfo.productInfos.count;
        CGFloat rowWid = (SDevWidth - (COLUMN+1)*ROWSPACE)/COLUMN;
        CGFloat rowhei = rowWid;
        
        CGFloat cellHeight = CGRectGetMaxY(lab.frame)+ROWSPACE;
        for (int i=0; i<total; i++) {
            int row = i / COLUMN;
            int column = i % COLUMN;
            StaticImgInfo *dInfo = _numInfo.productInfos[i];
            UIButton *btn = [self creatBtn];
            btn.frame = CGRectMake(ROWSPACE + rowWid*column + ROWSPACE * column,height+ ROWSPACE + (rowhei + ROWSPACE)*row, rowWid, rowhei);
            btn.tag = i;
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:dInfo.pic] forState:UIControlStateNormal];
            cellHeight = CGRectGetMaxY(btn.frame)+ROWSPACE;
        }
        self.bounds = CGRectMake(0, 0, SDevWidth, cellHeight);
    }
}

- (UIButton *)creatBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setLayerWithW:3 andColor:BordColor andBackW:0.5];
    [btn addTarget:self action:@selector(subCateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    return btn;
}

- (void)subCateBtnAction:(UIButton *)btn{
    
}

@end
