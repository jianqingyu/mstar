//
//  StaticNumberCell.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/11.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "StaticNumberCell.h"
#import "StaticNumInfo.h"
@implementation StaticNumberCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"textBCell";
    StaticNumberCell *imgCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (imgCell==nil) {
        imgCell = [[StaticNumberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        imgCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return imgCell;
}

- (void)setInfoArr:(NSArray *)infoArr{
    if (infoArr) {
        _infoArr = infoArr;
        [UIView animateWithDuration:0.1 animations:^{
            [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 18)];
        lab.font = [UIFont systemFontOfSize:15];
        CGFloat height = CGRectGetMaxY(lab.frame)+5;
        lab.text = @"统计范围";
        [self.contentView addSubview:lab];
        
        int COLUMN = 3;
        if (!IsPhone) {
            COLUMN = SDevHeight>SDevWidth?6:8;
        }else{
            COLUMN = SDevHeight>SDevWidth?3:6;
        }
        CGFloat ROWSPACE = 5;
        NSInteger total = _infoArr.count;
        CGFloat rowWid = (SDevWidth - (COLUMN+1)*ROWSPACE)/COLUMN;
        CGFloat rowhei = 30;
        
        CGFloat cellHeight = 0;
        for (int i=0; i<total; i++) {
            int row = i / COLUMN;
            int column = i % COLUMN;
            StaticNumInfo *dInfo = _infoArr[i];
            UIButton *btn = [self creatBtn];
            btn.frame = CGRectMake(ROWSPACE + rowWid*column + ROWSPACE * column,height+ ROWSPACE + (rowhei + ROWSPACE)*row, rowWid, rowhei);
            btn.tag = i;
            
            NSString *title = [NSString stringWithFormat:@"%@ : %@",dInfo.rangeTitle,dInfo.count];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
            [str addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(title.length-1,1)];
            [btn setAttributedTitle:str forState:UIControlStateNormal];
            cellHeight = CGRectGetMaxY(btn.frame)+5;
        }
        self.bounds = CGRectMake(0, 0, SDevWidth, cellHeight);
    }
}

- (UIButton *)creatBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [btn.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[CommonUtils createImageWithColor:MAIN_COLOR] forState:UIControlStateSelected];
    [btn setLayerWithW:3 andColor:BordColor andBackW:0.5];
    [btn addTarget:self action:@selector(subCateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    return btn;
}

- (void)subCateBtnAction:(UIButton *)btn{
    
}

@end
