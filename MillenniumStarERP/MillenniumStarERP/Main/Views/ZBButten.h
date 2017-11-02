//
//  ZBButten.h
//  ZBButten
//
//  Created by on 16/10/20.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBButten : UIButton
/**
 专用于定时器的butten默认是60秒
 */
@property(nonatomic,assign)int Timer;
/**
 初试的文字
 */
@property(nonatomic,strong)NSString *normaltext;
/**
 设置启动后的文字
 */
- (void)setbuttenfrontTitle:(NSString *)frontstr backtitle:(NSString *)backstr;
/**
 重启按钮
 */
- (void)resetBtn;
@end
