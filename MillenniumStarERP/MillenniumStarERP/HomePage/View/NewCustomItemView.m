//
//  NewCustomItemView.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/5/11.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "NewCustomItemView.h"
@interface NewCustomItemView()
@property (weak, nonatomic) IBOutlet UIImageView *itemImg;
@property (weak, nonatomic) IBOutlet UILabel *itemLab;

@end
@implementation NewCustomItemView

- (instancetype)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"NewCustomItemView" owner:nil options:nil][0];
    }
    return self;
}

- (void)setInfo:(NewCustomizationInfo *)info{
    if (info) {
        _info = info;
        [self.itemImg sd_setImageWithURL:[NSURL URLWithString:_info.picm] placeholderImage:DefaultImage];
        NSString *title = _info.title;
        if (self.number>0) {
            title = [NSString stringWithFormat:@"%@ /%d",title,self.number];
        }
        if (_info.pid.length>0) {
            self.itemLab.textColor = TextBColor;
        }else{
            self.itemLab.textColor = TextlColor;
        }
        self.itemLab.text = title;
    }
}

- (IBAction)itemClick:(id)sender {
    if (self.back) {
        self.back(sender);
    }
}

@end
