//
//  CustomLastCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "CustomLastCell.h"
@interface CustomLastCell()<UITextViewDelegate>

@end
@implementation CustomLastCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    CustomLastCell *addCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (addCell==nil) {
        addCell = [[CustomLastCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [addCell.textView setLayerWithW:3.0 andColor:BordColor andBackW:0.5];
        addCell.textView.placehoder = @"填写备注";
    }
    return addCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CustomLastCell" owner:nil options:nil][0];
        self.textView.delegate = self;
        self.textView.returnKeyType = UIReturnKeyNext;
    }
    return self;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [textView selectAll:nil];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (self.messBack) {
        self.messBack(textView.text,NO);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self.textView resignFirstResponder];
        //在这里做你响应return键的代码
        if (self.messBack) {
            self.messBack(textView.text,YES);
        }
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    if ([text isEqualToString:@"	"]) {
        return NO;
    }
    return YES;
}

- (void)setMessage:(NSString *)message{
    if (message) {
        _message = message;
        self.textView.text = _message;
        if (self.isNote) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self.textView becomeFirstResponder];
            });
        }
    }
}

@end
