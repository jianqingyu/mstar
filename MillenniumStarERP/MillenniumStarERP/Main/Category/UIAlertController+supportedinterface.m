//
//  UIAlertController+supportedinterface.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/6.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "UIAlertController+supportedinterface.h"

@implementation UIAlertController (supportedinterface)
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#endif
@end
