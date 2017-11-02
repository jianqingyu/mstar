//
//  NetworkView.m
//  MillenniumStar
//
//  Created by yjq on 15/8/5.
//  Copyright (c) 2015年 Millennium Star. All rights reserved.
//

#import "NetworkView.h"
#import "NoNetViewController.h"
@implementation NetworkView

+ (NetworkView *)creatSmallNetView{
    static NetworkView *_smallView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _smallView = [[NetworkView alloc]init];
    });
    return _smallView;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:
                                   @"NetworkView" owner:nil options:nil][0];
    }
    return self;
}

- (IBAction)gotoCLick:(id)sender {
    self.hidden = YES;
    NoNetViewController *noNetVc = [NoNetViewController new];
    noNetVc.loadBack = ^(BOOL isyes){
        self.hidden = NO;
    };
    [self.superNav pushViewController:noNetVc animated:YES];
}

@end
