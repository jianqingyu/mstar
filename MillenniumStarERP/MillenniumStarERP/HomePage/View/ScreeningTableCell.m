//
//  ScreeningTableCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/22.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ScreeningTableCell.h"
#import "ScreenDetailInfo.h"
#import "StrWithIntTool.h"
@interface ScreeningTableCell()<UITextFieldDelegate>
@property (nonatomic,strong)NSMutableArray *screenBtns;
@end
@implementation ScreeningTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"screenCell";
    ScreeningTableCell *addCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (addCell==nil) {
        addCell = [[ScreeningTableCell alloc]initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:Id];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return addCell;
}

- (void)setInfo:(ScreeningInfo *)info{
    if (info) {
        _info = info;
        self.screenBtns = @[].mutableCopy;
        [UIView animateWithDuration:0.1 animations:^{
            [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }];
        if (!info.isOpen) {
            CGFloat height = 0;
            if (!info.mulSelect) {
                UIView *view = [self setupTextField];
                height = CGRectGetMaxY(view.frame);
                [self setMinAndMaxFie:_wInfo];
            }
            NSInteger total = info.attributeList.count;
            for (int i=0; i<total; i++) {
                int row = i / COLUMN;
                int column = i % COLUMN;
                ScreenDetailInfo *dInfo = info.attributeList[i];
                UIButton *btn = [self creatBtn];
                btn.frame = CGRectMake(ROWSPACE + ROWWIDTH*column + ROWSPACE * column,
                        height+ ROWSPACE + (ROWHEIHT + ROWSPACE)*row, ROWWIDTH, ROWHEIHT);
                btn.tag = i;
                if (!info.mulSelect) {
                    if ([dInfo.value isEqualToString:_wInfo.value]) {
                        btn.selected = YES;
                    }
                }else{
                    btn.selected = dInfo.isSelect;
                }
                [OrderNumTool setCircularWithPath:btn size:CGSizeMake(3, 3)];
                [btn setTitle:dInfo.title forState:UIControlStateNormal];
                [self.screenBtns addObject:btn];
            }
        }
    }
}

- (UIView *)setupTextField{
    UIView *view = [[UIView alloc]initWithFrame:
                    CGRectMake(ROWSPACE, ROWSPACE, MIN(SDevHeight, SDevWidth)*0.8-20, ROWHEIHT)];
    view.backgroundColor = DefaultColor;
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    [self.contentView addSubview:view];
    UITextField *min = [self creatFieWithFrame:
                        CGRectMake(2, 2, (view.width-30)/2, ROWHEIHT-4)];
    min.placeholder = @"最小值";
    min.textColor = MAIN_COLOR;
    min.delegate = self;
    UITextField *max = [self creatFieWithFrame:
                        CGRectMake(view.width-min.width-2, 2, min.width, min.height)];
    max.placeholder = @"最大值";
    max.textColor = MAIN_COLOR;
    max.delegate = self;
    [view addSubview:min];
    [view addSubview:max];
    self.minFie = min;
    self.maxFie = max;
    UILabel *lin = [[UILabel alloc]initWithFrame:CGRectMake(min.width+10, (ROWHEIHT-5)/2, 10, 5)];
    lin.text = @"~";
    [view addSubview:lin];
    return view;
}

- (UITextField *)creatFieWithFrame:(CGRect)frame{
    UITextField *min = [[UITextField alloc]initWithFrame:frame];
    min.borderStyle = UITextBorderStyleRoundedRect;
    min.textAlignment = NSTextAlignmentCenter;
    min.keyboardType = UIKeyboardTypeDecimalPad;
    min.font = [UIFont systemFontOfSize:14];
    return min;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length>0) {
        for (int i=0; i<_info.attributeList.count; i++) {
            UIButton *sBtn = self.screenBtns[i];
            ScreenDetailInfo *dInfo = _info.attributeList[i];
            sBtn.selected = NO;
            dInfo.isSelect = NO;
        }
        [self backMaxminValue];
    }
}

- (UIButton *)creatBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[CommonUtils createImageWithColor:DefaultColor]
                   forState:UIControlStateNormal];
    [btn setBackgroundImage:[CommonUtils createImageWithColor:CUSTOM_COLOR(248, 205, 207)] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(subCateBtnAction:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    return btn;
}

- (void)subCateBtnAction:(UIButton *)btn{
    ScreenDetailInfo *dInfo = _info.attributeList[btn.tag];
    if (!_info.mulSelect) {
        for (int i=0; i<_info.attributeList.count; i++) {
            UIButton *sBtn = self.screenBtns[i];
            ScreenDetailInfo *dInfo = _info.attributeList[i];
            if (i!=(int)btn.tag) {
                sBtn.selected = NO;
                dInfo.isSelect = NO;
            }
        }
    }
    btn.selected = !btn.selected;
    if (!_info.mulSelect) {
        self.wInfo.value = btn.selected?dInfo.value:@"";
        [self setMinAndMaxFie:self.wInfo];
        return;
    }
    dInfo.isSelect = btn.selected;
}
//对最大最小值赋值
- (void)setMinAndMaxFie:(WeightInfo *)maxMin{
    NSArray *arr;
    if ([maxMin.value containsString:@"|"]) {
        arr = [maxMin.value componentsSeparatedByString:@"|"];
    }
    if (arr.count==0) {
        self.minFie.text = @"";
        self.maxFie.text = @"";
    }else{
        self.minFie.text = arr[0];
        self.maxFie.text = arr[1];
    }
}

- (void)backMaxminValue{
    if (self.minFie.text.length>0&&self.maxFie.text.length==0) {
        self.wInfo.value = [NSString stringWithFormat:@"%@|",self.minFie.text];
    }
    if (self.minFie.text.length==0&&self.maxFie.text.length>0) {
        self.wInfo.value = [NSString stringWithFormat:@"|%@",self.maxFie.text];
    }
    if (self.minFie.text.length>0&&self.maxFie.text.length>0) {
        self.wInfo.value = [NSString stringWithFormat:@"%@|%@",self.minFie.text,self.maxFie.text];
    }
    if (self.minFie.text.length==0&&self.maxFie.text.length==0) {
        self.wInfo.value = @"";
    }
}

@end
