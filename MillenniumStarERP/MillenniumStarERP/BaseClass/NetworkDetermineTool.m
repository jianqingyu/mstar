//
//  NetworkDetermineTool.m
//  MillenniumStar
//
//  Created by yjq on 15/8/5.
//  Copyright (c) 2015年 Millennium Star. All rights reserved.
//

#import "NetworkDetermineTool.h"
#import "Reachability.h"
#import "NetworkView.h"

@implementation NetworkDetermineTool
NetworkView *_networkView;
+ (void)isSView:(BOOL)isYes{
    UIWindow *netWindow = [[UIApplication sharedApplication].windows lastObject];
    netWindow.backgroundColor = [UIColor clearColor];
    _networkView = [NetworkView creatSmallNetView];
    _networkView.frame = CGRectMake(0, 64, SDevWidth, 44);
    if (!isYes) {
        [netWindow addSubview:_networkView];
    }else{
        [_networkView removeFromSuperview];
    }
}

+ (BOOL)isExistenceNet{
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
