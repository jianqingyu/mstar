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
@property (weak, nonatomic) IBOutlet UIView *drillView;
@property (weak, nonatomic) IBOutlet UILabel *driLab;
@end
@implementation NewCustomizationCollCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setLayerWithW:0.001 andColor:LineColor andBackW:0.5];
    // Initialization code
}

- (void)setInfo:(NewCustomizationInfo *)info{
    if (info) {
        _info = info;
        self.drillView.hidden = YES;
        [self.shopImg sd_setImageWithURL:[NSURL URLWithString:_info.picm] placeholderImage:DefaultImage];
        NSString *title = _info.title;
        if (self.isDef) {
            if (self.number>0) {
                title = [NSString stringWithFormat:@"%@ /%d",title,self.number];
            }
            if (_info.pid.length>0) {
                self.shopName.textColor = TextBColor;
            }else{
                self.shopName.textColor = TextlColor;
            }
        }
        self.shopName.text = title;
    }
}

- (void)setDrillStr:(NSString *)drillStr{
    if (drillStr) {
        _drillStr = drillStr;
        self.drillView.hidden = NO;
        self.driLab.text = _drillStr;
        BOOL isChoose = [_drillStr isEqualToString:@"选择裸钻"];
        UIColor *color = isChoose?TextlColor:TextBColor;
        self.driLab.textColor = color;
    }
}

@end
