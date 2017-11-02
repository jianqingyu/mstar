//
//  ScreenPopView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/26.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ScreenPopView.h"
#import "DetailTypeInfo.h"
#import "StrWithIntTool.h"
#import "WeightInfo.h"
#import "ScreenDetailInfo.h"
#define BCOLUMN 3
#define BROWWIDTH (SDevWidth - (BCOLUMN+1)*ROWSPACE)/BCOLUMN
@interface ScreenPopView ()
@property (nonatomic,strong)NSMutableDictionary *dictB;
@property (nonatomic,strong)NSArray *arrA;
@property (nonatomic,strong)NSArray *arrB;
@property (nonatomic,strong)NSMutableArray *mutA;
@property (nonatomic,strong)NSMutableArray *mutB;
@property (nonatomic,assign)int j;
@end
@implementation ScreenPopView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.mutA = @[].mutableCopy;
        self.mutB = @[].mutableCopy;
        self.dictB = @{}.mutableCopy;
        self.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
    }
    return self;
}

- (void)setList:(NSArray *)list{
    if (list) {
        _list = list;
        [self.mutA removeAllObjects];
        [self.mutB removeAllObjects];
        [_dictB removeAllObjects];
        [UIView animateWithDuration:0.1 animations:^{
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }];
        self.arrA = [ScreenDetailInfo objectArrayWithKeyValuesArray:_list[0]];
        [self.mutA addObjectsFromArray:self.arrA];
        
        NSMutableArray *mutarrB = @[].mutableCopy;
        NSArray * weightArr = [WeightInfo objectArrayWithKeyValuesArray:_list[1]];
        for (WeightInfo *info in weightArr) {
            if (info.value.length>0) {
                [mutarrB addObject:info];
            }
        }
        self.mutB = mutarrB;
        self.arrB = mutarrB.copy;
        
        NSInteger total = self.arrA.count;
        NSInteger rows = (total / COLUMN) + ((total % COLUMN) > 0 ? 1 : 0);
        CGFloat height = (float)ROWHEIHT * rows + ROWSPACE * (rows + 1);
        
        NSInteger Btotal = self.arrB.count;
        NSInteger Brows = (Btotal / BCOLUMN) + ((Btotal % BCOLUMN) > 0 ? 1 : 0);
        CGFloat Bheight = (float)ROWHEIHT * Brows + ROWSPACE * (Brows + 1);
        
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        backView.frame = CGRectMake(0, 0, SDevWidth, height+Bheight+40);
        [self addSubview:backView];
        
        for (int i=0; i<total; i++) {
            int row = i / COLUMN;
            int column = i % COLUMN;
            DetailTypeInfo *detail = self.arrA[i];
            UIButton *btn = [self creatBtnAction:@selector(subCateBtnAction:)];
            btn.frame = CGRectMake(ROWSPACE + ROWWIDTH*column + ROWSPACE * column,
                        ROWSPACE + (ROWHEIHT + ROWSPACE)*row, ROWWIDTH, ROWHEIHT);
            btn.tag = i;
            NSString *title = [NSString stringWithFormat:@"x %@",detail.title];
            [btn setTitle:title forState:UIControlStateNormal];
        }
        
        for (int j=0; j<Btotal ; j++) {
            int row = j / BCOLUMN;
            int column = j % BCOLUMN;
            UIButton *btn = [self creatBtnAction:@selector(subAnAction:)];
            btn.frame = CGRectMake(ROWSPACE + BROWWIDTH*column + ROWSPACE * column,
                        height+ROWSPACE + (ROWHEIHT + ROWSPACE)*row, BROWWIDTH, ROWHEIHT);
            btn.tag = j;
            WeightInfo *info = self.arrB[j];
            [btn setTitle:info.txt forState:UIControlStateNormal];
        }
        [self createBtnFrame:CGRectMake(0, height+Bheight, SDevWidth/2, 40) andTitle:@"确定"
                      andTag:10 andColor:MAIN_COLOR andTColor:[UIColor whiteColor]];
        [self createBtnFrame:CGRectMake(SDevWidth/2, height+Bheight, SDevWidth/2, 40)
                andTitle:@"重置筛选" andTag:20 andColor:DefaultColor andTColor:[UIColor blackColor]];
    }
}

- (void)createBtnFrame:(CGRect)frame andTitle:(NSString *)title andTag:(int)tag
              andColor:(UIColor *)color andTColor:(UIColor *)tColor{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitleColor:tColor forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
    [btn addTarget:self action:@selector(btnClick:)
                  forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (UIButton *)creatBtnAction:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = MAIN_COLOR.CGColor;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

- (void)subCateBtnAction:(UIButton *)btn{
    ScreenDetailInfo *detail = self.arrA[btn.tag];
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.layer.borderColor = DefaultColor.CGColor;
        [self.mutA removeObject:detail];
    }else{
        btn.layer.borderColor = MAIN_COLOR.CGColor;
        [self.mutA addObject:detail];
    }
}

- (void)subAnAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    WeightInfo *info = self.arrB[btn.tag];
    if (btn.selected) {
        btn.layer.borderColor = DefaultColor.CGColor;
        [self.mutB removeObject:info];
    }else{
        btn.layer.borderColor = MAIN_COLOR.CGColor;
        [self.mutB addObject:info];
    }
}

- (void)btnClick:(UIButton *)btn{
    NSMutableDictionary *mutB = @{}.mutableCopy;
    NSMutableDictionary *params = @{}.mutableCopy;
    for (ScreenDetailInfo *detail in self.mutA) {
        params[detail.groupKey] = @[].mutableCopy;
    }
    for (ScreenDetailInfo *detail in self.mutA) {
        NSMutableArray *mutA = params[detail.groupKey];
        [mutA addObject:detail.value];
    }
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj count]>0) {
            params[key] = [StrWithIntTool strWithArr:obj];
        }else{
            [params removeAllObjects];
        }
    }];
    [mutB addEntriesFromDictionary:params];
    for (WeightInfo *info in self.mutB) {
        mutB[info.name] = info.value;
    }
    if (btn.tag==10) {
        if (self.popBack) {
            self.popBack(mutB);
        }
    }else{
        if (self.popBack) {
            self.popBack(@{});
        }
    }
    [self removeFromSuperview];
}

@end
