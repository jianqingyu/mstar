//
//  KeyBoardView.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/3/16.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "KeyBoardView.h"

#define SCREEN_WIDTH         [UIScreen mainScreen].bounds.size.width
#define BOARDRATIO           (SDevHeight>SDevWidth?(224.0/275):(100.0/275))  //键盘的高宽比
#define KEYRATIO             (SDevHeight>SDevWidth?(86.0/63):(42.0/63))   //按键的高宽比

#define KEYBOARD_HEIGHT      (SCREEN_WIDTH * BOARDRATIO)    //键盘的高

#define BTN_WIDTH            (SCREEN_WIDTH / 10.0 - 6) //按键的宽
#define BTN_HEIGHT           (BTN_WIDTH * KEYRATIO)         //按键的高
#define ITEM_HEIGHT          (BTN_HEIGHT + 10)              //item的高

#define TOTAL_HEIGHT         (ITEM_HEIGHT * 4 + 50)

@implementation KeyBoardView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, TOTAL_HEIGHT);
        [self setData];
        [self setup];
    }
    return self;
}

- (void)setData{
    isUp = YES;
    
    for (int i = 1 ; i < 10 ; i ++)
    {
        KeyBoardModel * model = [KeyBoardModel new];
        model.isUpper = YES;
        model.key = [NSString stringWithFormat:@"%d",i];
        [self.modelArray addObject:model];
    }
    
    KeyBoardModel * model = [KeyBoardModel new];
    model.isUpper = YES;
    model.key = @"0";
    [self.modelArray addObject:model];
    
    for (NSInteger i = 0 ; i < 29 ; i ++ )
    {
        KeyBoardModel * model = [KeyBoardModel new];
        model.isUpper = YES;
        model.key = self.letterArray[i];
        
        [self.modelArray addObject:model];
    }
}

- (NSMutableArray *)modelArray{
    if (!_modelArray)
    {
        _modelArray = [NSMutableArray new];
    }
    return _modelArray;
}

- (NSArray *)letterArray{
    if (!_letterArray)
    {
        _letterArray = @[@"Q",@"W",@"E",@"R",@"T",@"Y",
                         @"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",
                         @"G",@"H",@"J",@"K",@"L",@"-",@"Z",@"X",
                         @"C",@"V",@"B",@"N",@"M",@".",@"#"];
    }
    return _letterArray;
}

- (UIButton *)clearBtn{
    if (!_clearBtn)
    {
        _clearBtn = [UIButton new];
        [_clearBtn setImage:[UIImage imageNamed:@"icon_keyclear"] forState:UIControlStateNormal];
        [_clearBtn setImage:[UIImage imageNamed:@"icon_keyclear"] forState:UIControlStateHighlighted];
        [_clearBtn addTarget:self action:@selector(ClearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_clearBtn];
        [_clearBtn setLayerWithW:3 andColor:BordColor andBackW:0.5];
        [_clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-3);
            make.bottom.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(BTN_WIDTH, BTN_HEIGHT));
        }];
    }
    return _clearBtn;
}

- (UIButton *)upBtn{
    if (!_upBtn){
        _upBtn = [UIButton new];
        [_upBtn setImage:[UIImage imageNamed:@"icon_keyup"] forState:UIControlStateNormal];
        [_upBtn setImage:[UIImage imageNamed:@"icon_keydown"] forState:UIControlStateHighlighted];
        [_upBtn addTarget:self action:@selector(UpBtnClick:)
                     forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_upBtn];
        [_upBtn setLayerWithW:0.01 andColor:BordColor andBackW:0.5];
        [_upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(3);
            make.bottom.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(BTN_WIDTH, BTN_HEIGHT));
        }];
    }
    return _upBtn;
}

- (UIView *)setupTopView{
    if (!_btnView){
        _btnView = [UIView new];
        [self addSubview:_btnView];
        _btnView.backgroundColor = BordColor;
        [_btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.left.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.height.mas_equalTo(40);
        }];
        
        UIButton *btn1 = [self creatBtn:@"系统键盘"];
        btn1.tag = 201;
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(3);
            make.top.mas_equalTo(5);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
        
        UIButton *btn2 = [self creatBtn:@"搜索"];
        btn2.tag = 202;
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-3);
            make.top.mas_equalTo(5);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
    }
    return _btnView;
}

- (UIButton *)creatBtn:(NSString *)title{
    UIButton *btn = [UIButton new];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(changeClick:)
              forControlEvents:UIControlEventTouchUpInside];
    [_btnView addSubview:btn];
    return btn;
}

- (void)changeClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(btnClick:andIndex:)]) {
        [self.delegate btnClick:self andIndex:btn.tag];
    }
}

- (void)setup{
    self.backgroundColor = DefaultColor;
    
    [self setupTopView];
//    [self upBtn];
    [self clearBtn];
    
    //topView
    CustomFlowLayout * topflowLayout = [[CustomFlowLayout alloc]init];
    topflowLayout.sectionInset = UIEdgeInsetsMake(10, 3, 0, 3);
    [topflowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
//    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH , ITEM_HEIGHT * 2);
    self.topView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:topflowLayout];
    [self addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_btnView.mas_bottom).with.offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(ITEM_HEIGHT*2);
    }];
    
    self.topView.delegate = self;
    self.topView.dataSource = self;
    self.topView.bounces = NO;
    self.topView.backgroundColor = [UIColor clearColor];
    [self.topView registerClass:[KeyBoardCell class] forCellWithReuseIdentifier:NSStringFromClass([KeyBoardCell class])];
    
    //middleView
    CustomFlowLayout * middleflowLayout = [[CustomFlowLayout alloc]init];
    middleflowLayout.sectionInset = UIEdgeInsetsMake(10, 3, 0, 3);
    [middleflowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
//    CGRect frame1 = CGRectMake(0, ITEM_HEIGHT * 2, SCREEN_WIDTH, ITEM_HEIGHT);
    self.middleView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:middleflowLayout];
    [self addSubview:self.middleView];
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).with.offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(ITEM_HEIGHT);
    }];
    
    self.middleView.delegate = self;
    self.middleView.dataSource = self;
    self.middleView.bounces = NO;
    self.middleView.backgroundColor = [UIColor clearColor];
    [self.middleView registerClass:[KeyBoardCell class] forCellWithReuseIdentifier:NSStringFromClass([KeyBoardCell class])];
    
    //bottomView
    CustomFlowLayout * bottomflowLayout = [[CustomFlowLayout alloc]init];
    bottomflowLayout.sectionInset = UIEdgeInsetsMake(10, 3, 0, 3);
    [bottomflowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
//    CGRect frame2 = CGRectMake(SCREEN_WIDTH/ 10.0, ITEM_HEIGHT * 3, SCREEN_WIDTH / 10.0 * 8.0, ITEM_HEIGHT);
    self.bottomView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:bottomflowLayout];
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleView.mas_bottom).with.offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(-SCREEN_WIDTH/10.0);
        make.height.mas_equalTo(ITEM_HEIGHT);
    }];
    
    self.bottomView.delegate = self;
    self.bottomView.dataSource = self;
    self.bottomView.bounces = NO;
    self.bottomView.backgroundColor = [UIColor clearColor];
    [self.bottomView registerClass:[KeyBoardCell class] forCellWithReuseIdentifier:NSStringFromClass([KeyBoardCell class])];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == self.topView)
    {
        return 2;
    }
    
    if (collectionView == self.middleView)
    {
        return 1;
    }
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.topView)
    {
        return 10;
    }
    
    if (collectionView == self.middleView)
    {
        return 10;
    }
    
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用cell
    KeyBoardCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KeyBoardCell class]) forIndexPath:indexPath];
    
    NSInteger index = indexPath.section * 10 + indexPath.item ;
    if (collectionView == self.middleView)
    {
        index = 20 + indexPath.section * 10 + indexPath.item ;
    }
    else if (collectionView == self.bottomView)
    {
        index = 30 + indexPath.section * 10 + indexPath.item ;
    }
    cell.tag = index + 100;
    cell.delegate = self;
    KeyBoardModel * model = (KeyBoardModel *)[self.modelArray objectAtIndex:index];
    KeyBoardModel * newmodel = [KeyBoardModel new];
    newmodel.key = model.key;
    newmodel.isUpper = isUp;
    
    cell.model = newmodel;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(BTN_WIDTH , BTN_HEIGHT);
}

#pragma mark - 设置每个UICollectionView最小垂直间距

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - 设置每个UICollectionView最小水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - KeyBoardCellDelgate
- (void)KeyBoardCellBtnClick:(NSInteger)Tag
{
    KeyBoardModel * model = (KeyBoardModel *)[self.modelArray objectAtIndex:Tag];
    if (!isUp && Tag > 9)
    {
        NSString * string = [model.key lowercaseString];
        [self inputString:string];
    }
    else
    {
        [self inputString:model.key];
    }
}

#pragma mark - Response Events
- (void)UpBtnClick:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    isUp = !isUp;
    UIImage * image = isUp ? [UIImage imageNamed:@"up_a"] : [UIImage imageNamed:@"up_b"];
    [sender setImage:image forState:UIControlStateNormal];
    
    [self.topView reloadData];
    [self.middleView reloadData];
    [self.bottomView reloadData];
    sender.userInteractionEnabled = YES;
}

- (void)ClearBtnClick:(UIButton *)sender
{
    if (self.inputSource)
    {
        if ([self.inputSource isKindOfClass:[UITextField class]])
        {
            UITextField *tmp = (UITextField *)self.inputSource;
            [tmp deleteBackward];
        }
        else if ([self.inputSource isKindOfClass:[UITextView class]])
        {
            UITextView *tmp = (UITextView *)self.inputSource;
            [tmp deleteBackward];
        }
        else if ([self.inputSource isKindOfClass:[UISearchBar class]])
        {
            UISearchBar *tmp = (UISearchBar *)self.inputSource;
            NSMutableString *info = [NSMutableString stringWithString:tmp.text];
            if (info.length > 0) {
                NSString *s = [info substringToIndex:info.length-1];
                [tmp setText:s];
            }
        }
    }
}

#pragma mark - Private Events
- (void)inputString:(NSString *)string
{
    if (self.inputSource)
    {
        //UITextField
        if ([self.inputSource isKindOfClass:[UITextField class]])
        {
            UITextField * tmp = (UITextField *)self.inputSource;
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
            {
                NSRange range = NSMakeRange(tmp.text.length, 1);
                BOOL ret = [tmp.delegate textField:tmp shouldChangeCharactersInRange:range replacementString:string];
                if (ret)
                {
                    [tmp insertText:string];
                }
            }
            else
            {
                [tmp insertText:string];
            }
        }
        //UITextView
        else if ([self.inputSource isKindOfClass:[UITextView class]])
        {
            UITextView * tmp = (UITextView *)self.inputSource;
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)])
            {
                NSRange range = NSMakeRange(tmp.text.length, 1);
                BOOL ret = [tmp.delegate textView:tmp shouldChangeTextInRange:range replacementText:string];
                if (ret)
                {
                    [tmp insertText:string];
                }
            }
            else
            {
                [tmp insertText:string];
            }
            
        }
        //UISearchBar
        else if ([self.inputSource isKindOfClass:[UISearchBar class]])
        {
            UISearchBar *tmp = (UISearchBar *)self.inputSource;
            NSMutableString * info = [NSMutableString stringWithString:tmp.text];
            [info appendString:string];
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)])
            {
                NSRange range = NSMakeRange(tmp.text.length, 1);
                BOOL ret = [tmp.delegate searchBar:tmp shouldChangeTextInRange:range replacementText:string];
                if (ret)
                {
                    [tmp setText:[info copy]];
                }
            }
            else
            {
                [tmp setText:[info copy]];
            }
        }
    }
}

@end
