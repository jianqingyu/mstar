//
//  YQItemTool.h
//  YQ微博
//
//  Created by tarena425 on 15/7/1.
//  Copyright (c) 2015年 ccyuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface YQItemTool : NSObject
+ (UIBarButtonItem *)setItem:(id)target Action:(SEL)action
                       image:(NSString *)image hightImage:(NSString *)hightImage;
+ (UIView *)setItem:(id)target Action:(SEL)action image:(NSString *)image
              title:(NSString *)title;
+ (UIView *)setBtn:(id)target Act:(SEL)action
               img:(NSString *)image str:(NSString *)title frame:(CGRect)frame;
@end
