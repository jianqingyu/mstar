//
//  SettlementTableCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/3.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SettlementTableCell.h"
@interface SettlementTableCell()
@property(nonatomic,weak)UIScrollView *backScroll;
@end
@implementation SettlementTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"setCell";
    SettlementTableCell *addCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (addCell==nil) {
        addCell = [[SettlementTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return addCell;
}

- (void)createScrollView:(CGRect)sFrame{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = sFrame;
    [self.contentView addSubview:scrollView];
    //设置scrollView的其他属性
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    self.backScroll = scrollView;
}

- (void)setInfo:(SettlementListInfo *)info{
    if (info) {
        _info = info;
        [UIView animateWithDuration:0.1 animations:^{
            [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }];
        [self creatBaseLab];
    }
}

- (void)creatBaseLab{
    NSInteger total = self.info.list.count;
    CGFloat labH = 24;
    CGFloat labW = 0;
    NSInteger ACount = 0;
    if (IsPhone) {
        labW = (int)(SDevWidth-20)/4;
        ACount = [self.info.list[0] count];
        [self createScrollView:CGRectMake(10+labW, 0, SDevWidth-10-labW, total*labH)];
        self.backScroll.contentSize = CGSizeMake((ACount-1)*labW+10, 0);
    }else{
        labW = (int)(SDevWidth-20)/7;
        ACount = 7;
    }
    for (int j=0; j<total; j++) {
        NSArray *arr = self.info.list[j];
        for (int i=0; i<ACount; i++) {
            UILabel *lab = [self creatLab];
            if (j==0||j==total-1) {
                lab.font = [UIFont systemFontOfSize:14];
                lab.backgroundColor = CUSTOM_COLOR(245, 245, 247);
            }
            if (IsPhone) {
                NSString *str = [NSString stringWithFormat:@"%@",arr[i]];
                lab.text = [self strWithStr:str];
                if (i==0) {
                    lab.frame = CGRectMake(10,j*labH, labW, labH);
                    [self.contentView addSubview:lab];
                }else{
                    lab.frame = CGRectMake(labW*(i-1),j*labH, labW, labH);
                    [self.backScroll addSubview:lab];
                }
            }else{
                lab.frame = CGRectMake(10+labW*i,j*labH, labW, labH);
                [self.contentView addSubview:lab];
                if (i<arr.count-1) {
                    NSString *str = [NSString stringWithFormat:@"%@",arr[i]];
                    lab.text = [self strWithStr:str];
                }
                if (i==ACount-1) {
                    NSString *str = [NSString stringWithFormat:@"%@",[arr lastObject]];
                    lab.text = [self strWithStr:str];
                }
            }
        }
    }
}

- (NSString *)strWithStr:(NSString *)str{
    if ([str containsString:@"."]) {
        NSRange range = [str rangeOfString:@"."];//匹配得到的下标
        if ((str.length - range.location)>2) {
            str = [str substringToIndex:(range.location+3)];//截取掉下标之后的字符串
        }
    }
    return str;
}

- (UILabel *)creatLab{
    UILabel *lab = [[UILabel alloc]init];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor darkGrayColor];
    lab.font = [UIFont systemFontOfSize:12];
    [lab setAdjustsFontSizeToFitWidth:YES];
    return lab;
}

@end
