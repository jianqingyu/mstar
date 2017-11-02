//
//  YQCustomBtn.h
//  MillenniumStarERP
//
//  Created by yjq on 16/12/2.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^callDeBack)(BOOL isYes);
@interface YQCustomBtn : UIView
- (void)setupBtnWithStr:(NSString *)str
                  andIm:(NSString *)img
                 andSIm:(NSString *)sImg;
@property (nonatomic, copy) callDeBack clickBlock ;
@end
