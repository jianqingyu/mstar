//
//  KeyBoardCell.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/3/16.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "KeyBoardCell.h"
#import "CustomShapeBtn.h"
@implementation KeyBoardCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self keyboardBtn];
}

- (UIButton *)keyboardBtn
{
    if (!_keyboardBtn)
    {
        _keyboardBtn = [UIButton new];
//        [_keyboardBtn setBackgroundImage:[UIImage imageNamed:@"keyboard_key"] forState:UIControlStateNormal];
        UIImage *backImg = [CommonUtils createImageWithColor:BordColor];
        UIImage *norImg = [CommonUtils createImageWithColor:[UIColor whiteColor]];
        [_keyboardBtn setBackgroundImage:norImg forState:UIControlStateNormal];
        [_keyboardBtn setBackgroundImage:backImg forState:UIControlStateHighlighted];
//        _keyboardBtn.backgroundColor = [UIColor whiteColor];
//        [_keyboardBtn setLayerWithW:2 andColor:BordColor andBackW:0.5];
        [_keyboardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_keyboardBtn addTarget:self action:@selector(KeyboardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_keyboardBtn];
        _keyboardBtn.frame = self.contentView.bounds;
        [OrderNumTool setCircularWithPath:_keyboardBtn size:CGSizeMake(3, 3)];
    }
    return _keyboardBtn;
}

- (void)KeyboardBtnClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KeyBoardCellBtnClick:)])
    {
        [self.delegate KeyBoardCellBtnClick:self.tag - 100];
    }
}

- (void)setModel:(KeyBoardModel *)model
{
    if (_model != model)
    {
        _model = model;
        
        if(!model.isUpper && self.tag > 9 + 100)
        {
            NSString * string = [model.key lowercaseString];
            
            [self.keyboardBtn setTitle:string forState:UIControlStateNormal];
        }
        else
        {
            [self.keyboardBtn setTitle:model.key forState:UIControlStateNormal];
        }
    }
}

@end