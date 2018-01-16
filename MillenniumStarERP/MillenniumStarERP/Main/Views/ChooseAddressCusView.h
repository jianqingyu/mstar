//
//  ChooseAddressCusView.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/1/16.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ChAddInfoBack)(NSDictionary *store,BOOL isSel);
@interface ChooseAddressCusView : UIView
+ (ChooseAddressCusView *)createLoginView;
@property (nonatomic, copy)ChAddInfoBack storeBack;
@property (nonatomic, copy)NSString *areaCode;
@end
