//
//  DetailTextCustomView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/12/28.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "DetailTextCustomView.h"
#import "DetailTypeInfo.h"
@interface DetailTextCustomView()<UITextFieldDelegate>
@end
@implementation DetailTextCustomView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
        UIView *back = [[UIView alloc]init];
        back.backgroundColor = [UIColor whiteColor];
        [self addSubview:back];
        [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SDevWidth*0.8, 168));
        }];
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.font = [UIFont systemFontOfSize:18];
        titleLab.backgroundColor = DefaultColor;
        titleLab.textAlignment = NSTextAlignmentCenter;
        [back addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(back).offset(0);
            make.top.equalTo(back).offset(0);
            make.right.equalTo(back).offset(0);
            make.height.mas_equalTo(@44);
        }];
        self.topLab = titleLab;
        
        UITextField *textFie = [[UITextField alloc]init];
        textFie.delegate = self;
        textFie.borderStyle = UITextBorderStyleRoundedRect;
        textFie.textAlignment = NSTextAlignmentCenter;
        textFie.placeholder = @"规格值";
        [back addSubview:textFie];
        [textFie mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLab.mas_bottom).with.offset(20);
            make.centerX.mas_equalTo(back.mas_centerX);
            make.width.mas_equalTo(SDevWidth*0.4);
            make.height.mas_equalTo(@30);
        }];
        self.scanfText = textFie;
        
        UIButton *accBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [accBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
        [accBtn addTarget:self action:@selector(accClick:) forControlEvents:UIControlEventTouchUpInside];
        [back addSubview:accBtn];
        [accBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLab.mas_bottom).with.offset(20);
            make.right.equalTo(textFie.mas_left).with.offset(-10);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@30);
        }];
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setImage:[UIImage imageNamed:@"icon_acc"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
        [back addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLab.mas_bottom).with.offset(20);
            make.left.equalTo(textFie.mas_right).with.offset(10);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@30);
        }];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        cancel.backgroundColor = DefaultColor;
        [back addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(back).offset(0);
            make.bottom.equalTo(back).offset(0);
            make.height.mas_equalTo(@44);
            make.width.mas_equalTo(SDevWidth*0.4);
        }];
        
        UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
        [sure setTitle:@"确定" forState:UIControlStateNormal];
        [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sure addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
        sure.backgroundColor = MAIN_COLOR;
        [back addSubview:sure];
        [sure mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SDevWidth*0.4);
            make.bottom.equalTo(back).offset(0);
            make.height.mas_equalTo(@44);
            make.right.equalTo(back).offset(0);
        }];
    }
    return self;
}

- (void)accClick:(id)sender{
    float str = [self.scanfText.text floatValue];
    if (str==0.1||str<0.1) {
        return;
    }
    str = str-0.1;
    self.scanfText.text = [NSString stringWithFormat:@"%0.2f",str];
}

- (void)addClick:(id)sender{
    float str = [self.scanfText.text floatValue];
    str = str+0.1;
    self.scanfText.text = [NSString stringWithFormat:@"%0.2f",str];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    float str = [textField.text floatValue];
    textField.text = [NSString stringWithFormat:@"%0.2f",str];
}

- (void)btnClick:(id)sender{
    DetailTypeInfo *info = [DetailTypeInfo new];
    info.title = @"";
    if (self.textBack) {
        self.textBack(@{self.section:info});
        [self removeFromSuperview];
    }
}

- (void)sureClick:(id)sender{
    if (self.scanfText.text.length==0||[self.scanfText.text isEqualToString:@"0.00"]) {
        [MBProgressHUD showError:@"请输入规格"];
        return;
    }
    NSString *regiUrl = [NSString stringWithFormat:@"%@CheckSpecificationsForm",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"value"] = self.scanfText.text;
    
    NSMutableDictionary *mud = @{}.mutableCopy;
    DetailTypeInfo *info = [DetailTypeInfo new];
    info.title = self.scanfText.text;
    mud[self.section] = info;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if (self.textBack) {
                self.textBack(mud);
                [self removeFromSuperview];
            }
        }else{
            [MBProgressHUD showError:response.message];
        }
    }requestURL:regiUrl params:params];
}

@end
