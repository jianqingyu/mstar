//
//  NakedDriSeaTableCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriSeaTableCell.h"
#import "CustomShapeBtn.h"
@interface NakedDriSeaTableCell()
@property (nonatomic,strong)NSMutableArray *mutBtns;
@end
@implementation NakedDriSeaTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"textSCell";
    NakedDriSeaTableCell *imgCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (imgCell==nil) {
        imgCell = [[NakedDriSeaTableCell alloc]initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:Id];
        imgCell.selectionStyle = UITableViewCellSelectionStyleNone;
        imgCell.mutBtns = [NSMutableArray array];
    }
    return imgCell;
}

- (void)setSeaInfo:(NakedDriSeaListInfo *)seaInfo{
    if (seaInfo) {
        _seaInfo = seaInfo;
        UIColor *baColor = self.isEvenNum?DefaultColor:[UIColor whiteColor];
        self.backgroundColor = _seaInfo.isSel?CUSTOM_COLOR(250, 210, 184):baColor;
        NSArray *arr = [self arrWithModel];
        if (self.mutBtns.count==0) {
            [self creatBtnWithInfo:arr];
        }else{
            for (int i=0; i<arr.count; i++) {
                UIButton *btn = self.mutBtns[i];
                [btn setTitle:arr[i] forState:UIControlStateNormal];
                if (i==0) {
                    btn.selected = _seaInfo.isSel;
                }
            }
        }
    }
}

- (void)creatBtnWithInfo:(NSArray *)arr{
    NSInteger total = arr.count;
    CGFloat rowWid = 80;
    CGFloat rowhei = 30;
    for (int i=0; i<total; i++) {
        UIButton *btn = [self creatBtn];
        btn.frame = CGRectMake(rowWid*i,0, rowWid, rowhei);
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        if (i==0) {
            btn.selected = _seaInfo.isSel;
            btn.userInteractionEnabled = YES;
            [btn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"icon_select4"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"icon_select3"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(subCateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i==total-2) {
            btn.width = rowWid+40;
        }
        if (i==total-1) {
            btn.x = rowWid*i+40;
            btn.userInteractionEnabled = YES;
            [btn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.mutBtns addObject:btn];
    }
}

- (NSArray *)arrWithModel{
    NSString *str = self.cusType>1?@"定制":@"";
    NSArray *arr = @[str,[self str:_seaInfo.Weight],[self str:_seaInfo.Price],
                     [self str:_seaInfo.Shape],[self str:_seaInfo.Color],[self str:_seaInfo.Purity],
                     [self str:_seaInfo.Cut],[self str:_seaInfo.Polishing],
                     [self str:_seaInfo.Symmetric],[self str:_seaInfo.Fluorescence],
                     [self str:_seaInfo.CertAuth],[self str:_seaInfo.CertCode],@"报价"];
    if (!self.isShow) {
        NSMutableArray *mutA = arr.mutableCopy;
        [mutA removeObjectAtIndex:2];
        arr = mutA.copy;
    }
    return arr;
}

- (NSString *)str:(NSString *)mes{
    NSString *arrStr;
    if (mes.length>0) {
        arrStr = mes;
    }else{
        arrStr = @"";
    }
    if ([mes containsString:@"."]) {
        NSRange range = [mes rangeOfString:@"."];
        if (mes.length>range.location+2) {
            mes = [mes substringToIndex:range.location+3];
        }
        arrStr = mes;
    }
    return arrStr;
}

- (UIButton *)creatBtn{
    CustomShapeBtn *btn = [CustomShapeBtn buttonWithType:UIButtonTypeCustom];
    btn.userInteractionEnabled = NO;
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [btn.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.contentView addSubview:btn];
    return btn;
}

- (void)btnClick:(id)sender{
    if (!self.isShow) {
        [MBProgressHUD showError:@"不能报价"];
        return;
    }
    if (self.back) {
        self.back(YES);
    }
}

- (void)subCateBtnAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    _seaInfo.isSel = btn.selected;
    if (self.back) {
        self.back(NO);
    }
}

@end
