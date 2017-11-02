//
//  HomeHeadView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/7.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "HomeHeadView.h"

@implementation HomeHeadView
+ (HomeHeadView *)view{
    return [[NSBundle mainBundle] loadNibNamed:@"HomeHeadView" owner:nil options:nil][0];
}

- (void)setUserInfo:(UserInfo *)userInfo{
    if (userInfo) {
        _userInfo = userInfo;
        self.titleImg.layer.cornerRadius = self.titleImg.width/2;
        self.titleImg.layer.masksToBounds = YES;
        self.custom.layer.cornerRadius = 8;
        self.custom.layer.masksToBounds = YES;
        self.custom.layer.borderWidth = 0.8;
        self.custom.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.titleImg sd_setImageWithURL:[NSURL URLWithString:_userInfo.headPic] placeholderImage:DefaultImage];
        self.name.text = _userInfo.userName;
    }
}

@end
