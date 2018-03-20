//
//  YQTextView.m
//  清风微博
//
//  Created by tarena425 on 15/7/7.
//  Copyright (c) 2015年 ccyuqing. All rights reserved.
//

#import "YQTextView.h"
@implementation YQTextView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //监听 通知可以设置添加无数个监听器
        //当UITextView的文字发生改变时,UITextView自己会发出一个通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        self.layer.borderColor = [[UIColor grayColor]CGColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
//        self.layer.borderColor = [[UIColor grayColor]CGColor];
//        self.layer.borderWidth = 1;
//        self.layer.cornerRadius = 6;
//        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)textDidChange{
    //重绘
    [self setNeedsDisplay];
}
/**一赋值则重绘*/
- (void)setPlacehoder:(NSString *)placehoder{
    _placehoder = [placehoder copy];
    [self setNeedsDisplay];
}
- (void)setPlacehoderColor:(UIColor *)placehoderColor{
    _placehoderColor = placehoderColor;
    [self setNeedsDisplay];
}
/**手动改变文字才有通知*/
- (void)setText:(NSString *)text{
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (self.hasText) return;//有文字就返回
    //没文字就画字符串
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placehoderColor?self.placehoderColor:[UIColor grayColor];
    CGRect placeRect = CGRectMake(5, 8, rect.size.width-10, rect.size.height-16);
    
    [self.placehoder drawInRect:placeRect withAttributes:attrs];
}

//销毁通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
