//
//  SetDriScopeView.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/9.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "SetDriScopeView.h"
#import "FMDataTool.h"
@interface SetDriScopeView()
@property (weak, nonatomic) IBOutlet UITextField *minFie;
@property (weak, nonatomic) IBOutlet UITextField *maxFie;
@property (weak, nonatomic) IBOutlet UITextField *numFie;
@property (weak, nonatomic) IBOutlet UIView *allView;
@property (weak, nonatomic) IBOutlet UIButton *canBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@end

@implementation SetDriScopeView

+ (id)creatSetDriView{
    SetDriScopeView *driV = [[NSBundle mainBundle]loadNibNamed:@"SetDriScopeView"
                                                         owner:nil options:nil][0];
    [driV.allView setLayerWithW:3 andColor:BordColor andBackW:0.001];
    [driV.canBtn setLayerWithW:3 andColor:BordColor andBackW:0.001];
    [driV.sureBtn setLayerWithW:3 andColor:BordColor andBackW:0.001];
    return driV;
}

- (void)setInfo:(SetDriInfo *)info{
    if (info) {
        _info = info;
        NSArray *arr;
        if ([_info.scope containsString:@"~"]) {
            arr = [_info.scope componentsSeparatedByString:@"~"];
        }
        if (arr.count!=0) {
            self.minFie.text = arr[0];
            self.maxFie.text = arr[1];
        }
        self.numFie.text = _info.number;
    }
}

- (IBAction)cancelClick:(id)sender {
    [self registerThirdTextFie];
    if (self.back) {
        self.back(NO,nil);
    }
}

- (void)registerThirdTextFie{
    [self.minFie resignFirstResponder];
    [self.maxFie resignFirstResponder];
    [self.numFie resignFirstResponder];
}

- (IBAction)confirmClick:(id)sender {
    [self registerThirdTextFie];
    if (_index) {
        [self updataInfoDataBase];
    }else{
        [self addInfoDataBase];
    }
}

- (void)addInfoDataBase{
    if (![self isCompare]) {
        [MBProgressHUD showError:@"规格有误"];
        return;
    }
    
    NSString *scope = [self strWithTextFie];
    NSArray *arr = [[FMDataTool sharedDataBase]getInfoArrFromSql:scope];
    if (arr.count==0) {
        SetDriInfo *dri = [SetDriInfo new];
        dri.scope = scope;
        dri.number = self.numFie.text;
        dri.isSel = @(YES);
        if (self.back) {
            self.back(YES,dri);
        }
        [[FMDataTool sharedDataBase]addDriInfo:dri];
    }else{
        [MBProgressHUD showError:@"已经有相同记录"];
    }
}

- (void)updataInfoDataBase{
    if (![self isCompare]) {
        [MBProgressHUD showError:@"规格有误"];
        return;
    }
    SetDriInfo *dri = [SetDriInfo new];
    dri.scope = [self strWithTextFie];
    dri.number = self.numFie.text;
    dri.isSel = @(YES);
    dri.ID = self.info.ID;
    [[FMDataTool sharedDataBase]updateDriInfo:dri];
    if (self.back) {
        self.back(YES,@{@(_index):dri});
    }
}

- (NSString *)strWithTextFie{
    NSString *str;
    if (self.maxFie.text.length==0) {
        str = [NSString stringWithFormat:@"%@~",self.minFie.text];
    }else{
        str = [NSString stringWithFormat:@"%@~%@",self.minFie.text,self.maxFie.text];
    }
    return str;
}

- (BOOL)isCompare{
    BOOL minZero = self.minFie.text.length==0;
    BOOL maxZero = self.maxFie.text.length==0;
    if (minZero&&!maxZero) {
        return YES;
    }
    if (!minZero&&maxZero) {
        return YES;
    }
    BOOL isMin = [self isPureInt:self.minFie.text];
    BOOL isMax = [self isPureInt:self.maxFie.text];
    if (!isMin||!isMax) {
        return NO;
    }
    int min = [self.minFie.text intValue];
    int max = [self.minFie.text intValue];
    if (min>max) {
        return NO;
    }
    return YES;
}
//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断字符串是否为浮点数
//- (BOOL)isPureFloat:(NSString*)string{
//    NSScanner* scan = [NSScanner scannerWithString:string];
//    float val;
//    return[scan scanFloat:&val] && [scan isAtEnd];
//}
//- (NSString *)strWithFloat:(NSString *)floatStr{
//    float f = [floatStr floatValue];
//    return [NSString stringWithFormat:@"%0.2f",f];
//}

@end
