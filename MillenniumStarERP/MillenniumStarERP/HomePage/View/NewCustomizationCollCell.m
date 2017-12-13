//
//  NewCustomizationCollCell.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2017/12/12.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NewCustomizationCollCell.h"
@interface NewCustomizationCollCell()
@property (weak, nonatomic) IBOutlet UIImageView *shopImg;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *typeNum;
@end
@implementation NewCustomizationCollCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setLayerWithW:0.001 andColor:BordColor andBackW:0.5];
    // Initialization code
}

- (void)setInfo:(NewCustomizationInfo *)info{
    if (info) {
        _info = info;
        [self.shopImg sd_setImageWithURL:[NSURL URLWithString:_info.picm] placeholderImage:DefaultImage];
        self.shopName.text = _info.title;
        self.typeNum.hidden = YES;
    }
}

- (void)setNumber:(int)number{
    [OrderNumTool orderWithNum:number andView:self.typeNum];
}

@end
