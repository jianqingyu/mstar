//
//  ConfirmBaseCollCell.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/17.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "ConfirmBaseCollCell.h"
@interface ConfirmBaseCollCell()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cellBtns;
@property (weak, nonatomic) IBOutlet UIImageView *shopImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *driInfoLab;
@end
@implementation ConfirmBaseCollCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setListInfo:(OrderListInfo *)listInfo{
    if (listInfo) {
        _listInfo = listInfo;
        UIButton *btn = self.cellBtns[0];
        btn.selected = _listInfo.isSel;
        [self.shopImg sd_setImageWithURL:[ NSURL URLWithString:_listInfo.pic] placeholderImage:DefaultImage];
        self.titleLab.text = _listInfo.title;
        NSString *mess = [NSString stringWithFormat:@"%@,成色:%@",
                          _listInfo.baseInfo,_listInfo.purityName];
        self.detailLab.text = _listInfo.purityName.length>0?mess:_listInfo.baseInfo;
        self.priceLab.hidden = [[AccountTool account].isNoShow intValue];
        self.priceLab.text = [OrderNumTool strWithPrice:_listInfo.price];
        self.numLab.text = [NSString stringWithFormat:@"%@件",_listInfo.number];
        self.driInfoLab.text = _listInfo.info;
    }
}

- (void)setIsBtnHidden:(BOOL)isBtnHidden{
    if (isBtnHidden) {
        _isBtnHidden = isBtnHidden;
        [self.cellBtns[0] setHidden:YES];
    }
}

- (void)setIsTopHidden:(BOOL)isTopHidden{
    if (isTopHidden) {
        _isTopHidden = isTopHidden;
        [self.topView removeFromSuperview];
    }
}

- (IBAction)cellClick:(UIButton *)sender {
    NSInteger index = [self.cellBtns indexOfObject:sender];
    if ([self.delegate respondsToSelector:@selector(baseCellClick:andIndex:)]) {
        [self.delegate baseCellClick:self andIndex:index];
    }
}

@end
