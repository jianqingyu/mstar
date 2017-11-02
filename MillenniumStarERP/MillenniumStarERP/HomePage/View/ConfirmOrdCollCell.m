//
//  ConfirmOrdCollCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/8/7.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "ConfirmOrdCollCell.h"
@interface ConfirmOrdCollCell()
@property (weak, nonatomic) IBOutlet UIImageView *picImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *baseLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allBtns;
@end
@implementation ConfirmOrdCollCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setListInfo:(OrderListInfo *)listInfo{
    if (listInfo) {
        _listInfo = listInfo;
        UIButton *btn = self.allBtns[0];
        btn.selected = _listInfo.isSel;
        [self.picImg sd_setImageWithURL:[ NSURL URLWithString:_listInfo.pic] placeholderImage:DefaultImage];
        self.titleLab.text = _listInfo.title;
        self.baseLab.text = _listInfo.baseInfo;
        self.priceLab.hidden = [[AccountTool account].isNoShow intValue];
        self.priceLab.text = [OrderNumTool strWithPrice:_listInfo.price];
        self.numLab.text = [NSString stringWithFormat:@"%@件",_listInfo.number];
        self.infoLab.text = _listInfo.info;
    }
}

- (void)setIsBtnHidden:(BOOL)isBtnHidden{
    if (isBtnHidden) {
        _isBtnHidden = isBtnHidden;
        [self.allBtns[0] setHidden:YES];
    }
}

- (void)setIsTopHidden:(BOOL)isTopHidden{
    if (isTopHidden) {
        _isTopHidden = isTopHidden;
        [self.topView removeFromSuperview];
    }
}

- (IBAction)allClick:(UIButton *)sender {
    NSInteger index = [self.allBtns indexOfObject:sender];
    [self.delegate btnCellClick:self andIndex:index];
}

@end
