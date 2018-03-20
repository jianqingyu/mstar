//
//  ProductCollectionCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/9.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "ProductCollectionCell.h"
@interface ProductCollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *bottomV;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (nonatomic,assign)BOOL isSel;
@end
@implementation ProductCollectionCell
//数据更新
- (void)setProInfo:(ProductInfo *)proInfo{
    if (proInfo) {
        _proInfo = proInfo;
//        if (!_isSel) {
//            [self setLayerWithW:0.001 andColor:MAIN_COLOR andBackW:0.5];
//        }
        self.bottomV.hidden = self.isShow;
        self.titleLab.text = _proInfo.title;
        NSString *image = _proInfo.pic;
        if (!IsPhone) {
            image = _proInfo.picm;
        }
        [self.headView sd_setImageWithURL:[NSURL URLWithString:image]
                         placeholderImage:DefaultImage];
        self.priceLab.text = [OrderNumTool strWithPrice:_proInfo.price];
        _isSel = YES;
    }
}

@end
