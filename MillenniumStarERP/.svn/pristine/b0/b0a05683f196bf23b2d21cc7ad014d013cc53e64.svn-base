//
//  NearbyNetworkView.m
//  MillenniumStar
//
//  Created by yjq on 15/8/5.
//  Copyright (c) 2015年 Millennium Star. All rights reserved.
//

#import "NearbyNetworkView.h"
#import "Reachability.h"
@implementation NearbyNetworkView
+ (NearbyNetworkView *)creatBigNetView{
    static NearbyNetworkView *_bigView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bigView = [[NearbyNetworkView alloc]init];
    });
    return _bigView;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:
                @"NearbyNetworkView" owner:nil options:nil][0];
    }
    return self;
}

- (IBAction)reloadClick:(id)sender {
    BOOL isWifi = [self isExistenceNet];
    if (isWifi) {
        [self removeFromSuperview];
        if (self.loadBack) {
            self.loadBack(isWifi);
        }
    }
}

- (BOOL)isExistenceNet{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            return NO;
            break;
        case ReachableViaWWAN:
            return YES;
            break;
        case ReachableViaWiFi:
            return YES;
            break;
    }
}

@end
