//
//  MenuHrizontal.m
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import "UserManagerMenuHrizontal.h"
#import "CommonUtils.h"

@implementation UserManagerMenuHrizontal
- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)aItemsArray{
    self = [super initWithFrame:frame];
    if (self) {
        if (mButtonArray == nil) {
            mButtonArray = [[NSMutableArray alloc] init];
        }
        if (_mScrollView == nil) {
            _mScrollView = [[UIScrollView alloc]init];
            _mScrollView.showsHorizontalScrollIndicator = YES;
            _mScrollView.showsVerticalScrollIndicator = NO;
            [self addSubview:_mScrollView];
        }
        if (mItemInfoArray == nil) {
            mItemInfoArray = [[NSMutableArray alloc]init];
        }
        if (mLabArray == nil) {
            mLabArray = [NSMutableArray array];
        }
        [mItemInfoArray removeAllObjects];
        [self createMenuItems:aItemsArray];
    }
    return self;
}

- (void)setImgArr:(NSArray *)imgArr{
    if (imgArr) {
        _imgArr = imgArr;
        for (int i=0; i<_imgArr.count; i++) {
            UILabel *lab = mLabArray[i];
            int cum = [_imgArr[i]intValue];
            [OrderNumTool orderWithNum:cum andView:lab];
        }
    }
}

- (void)createMenuItems:(NSArray *)itemArray{
    UIButton *lastButton = nil;
    for (int i=0; i<itemArray.count; i++) {
        NSDictionary *dic = itemArray[i];
        NSString *buttonTitle = dic[@"title"];
        UIButton *button = [self creatBtn:buttonTitle andI:i];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_mScrollView).offset(0);
            make.bottom.equalTo(_mScrollView).offset(0);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(_mScrollView.mas_width).multipliedBy(1.0/itemArray.count);
            if (lastButton) {
                make.left.mas_equalTo(lastButton.mas_right).with.offset(0);
            } else {
                make.left.mas_equalTo(_mScrollView).offset(0);
            }
        }];
        lastButton = button;
        
        UILabel *lab = [self creatLab:button];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button).offset(3);
            make.right.equalTo(button).offset(-3);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
    }
    [_mScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.right.mas_equalTo(lastButton.mas_right).offset(0);
    }];
}

- (UIButton *)creatBtn:(NSString *)buttonTitle andI:(int)i{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[CommonUtils createImageWithColor:[UIColor whiteColor]]
                      forState:UIControlStateNormal];
    button.tag = i;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setBackgroundImage:[UIImage imageNamed:@"frame"] forState:UIControlStateSelected];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_mScrollView addSubview:button];
    [mButtonArray addObject:button];
    return button;
}
//数量
- (UILabel *)creatLab:(UIButton *)button{
    UILabel *lab = [[UILabel alloc]init];
    lab.hidden = YES;
    lab.layer.cornerRadius = 8;
    lab.layer.masksToBounds = YES;
    lab.backgroundColor = MAIN_COLOR;
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:12];
    lab.textAlignment = NSTextAlignmentCenter;
    //根据宽度适配文字大小
    lab.adjustsFontSizeToFitWidth = YES;
    [button addSubview:lab];
    [mLabArray addObject:lab];
    return lab;
}
#pragma mark - 其他辅助功能
#pragma mark 模拟选中第几个button
- (void)clickButtonAtIndex:(NSInteger)aIndex{
    UIButton *vButton = [mButtonArray objectAtIndex:aIndex];
    [self menuButtonClicked:vButton];
}
#pragma mark 取消所有button点击状态
- (void)changeButtonsToNormalState{
    for (UIButton *vButton in mButtonArray) {
        vButton.selected = NO;
    }
}
#pragma mark 改变第几个button为选中状态，不发送delegate
- (void)changeButtonStateAtIndex:(NSInteger)aIndex{
    UIButton *vButton = [mButtonArray objectAtIndex:aIndex];
    [self changeButtonsToNormalState];
    vButton.selected = YES;
}
#pragma mark - 点击事件
- (void)menuButtonClicked:(UIButton *)aButton{
    [self changeButtonStateAtIndex:aButton.tag];
    if ([_delegate respondsToSelector:@selector(didMenuHrizontalClickedButtonAtIndex:)]) {
        [_delegate didMenuHrizontalClickedButtonAtIndex:aButton.tag];
    }
}

@end
