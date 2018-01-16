//
//  CustomFirstCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "CustomFirstCell.h"

@interface CustomFirstCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleFie;
@property (weak, nonatomic) IBOutlet UILabel *ptLab;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIView *driView;
@property (weak, nonatomic) IBOutlet UILabel *codeLab;
@property (weak, nonatomic) IBOutlet UIButton *accBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@end
@implementation CustomFirstCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"firstCell";
    CustomFirstCell *addCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (addCell==nil) {
        addCell = [[CustomFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return addCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CustomFirstCell" owner:nil options:nil][0];
        [self setBaseView];
    }
    return self;
}

- (void)setBaseView{
    self.titleFie.tag = 1;
    self.titleFie.delegate = self;
    
    self.fie1.tag = 2;
    self.fie1.delegate = self;
    
    self.handFie.tag = 3;
    self.handFie.delegate = self;
    self.handFie.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    self.handFie.inputAccessoryView = [[UIView alloc] init];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag==3) {
        [self handClick];
        return;
    }
    if (textField.tag==1) {
        if (self.dBack) {
            self.dBack(YES);
        }
    }
    [textField selectAll:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==1&&![textField.text isEqualToString:_modelInfo.title]) {
        [self loadSearchProduct:textField.text];
        return;
    }
    if (textField.tag==2) {
        [self backText:[textField.text floatValue]];
        return;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag==2) {
       [self backText:[textField.text floatValue]];
        [self.handFie becomeFirstResponder];
        return YES;
    }
    if (textField.tag==1&&[textField.text isEqualToString:_modelInfo.title]) {
        [self.fie1 becomeFirstResponder];
        return YES;
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)loadSearchProduct:(NSString *)search{
    NSString *url = [NSString stringWithFormat:@"%@ModelDetailPageGetInfoByModelNum",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"modelNum"] = search;
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0&&[YQObjectBool boolForObject:response.data]) {
            if (self.MessBack) {
                self.MessBack(NO,response.data[@"id"]);
            }
        }else{
            [self.titleFie becomeFirstResponder];
            self.titleFie.text = _modelInfo.title;
            [MBProgressHUD showError:response.message];
        }
    } requestURL:url params:params];
}

- (void)handClick{
    if (self.MessBack) {
        self.MessBack(NO,@"");
    }
}

- (IBAction)accClick:(id)sender {
    float str = [self.fie1.text floatValue];
    if (str==0.5||str==1) {
        return;
    }
    str--;
    [self backText:str];
}

- (IBAction)addClick:(id)sender {
    float str = [self.fie1.text floatValue];
    str++;
    [self backText:str];
}

- (void)backText:(float)str{
    NSString *string = [NSString stringWithFormat:@"%0.1f",str];
    if (!(fmodf(str, 1)==0.5||fmodf(str, 1)==0)||str<0||str==0) {
        [MBProgressHUD showError:@"只能填整数或者x.5"];
        self.fie1.text = @"1";
        if (self.MessBack) {
            self.MessBack(YES,self.fie1.text);
        }
        return;
    }
    if ([string rangeOfString:@".5"].location != NSNotFound) {
        self.fie1.text = string;
    }else{
        self.fie1.text = [NSString stringWithFormat:@"%0.0f",str];
    }
    if (self.MessBack) {
        self.MessBack(YES,self.fie1.text);
    }
}

- (void)setCertCode:(NSString *)certCode{
    if (certCode) {
        _certCode = certCode;
        if (!_isNew) {
            self.driView.hidden = !_certCode.length;
            self.codeLab.text = _certCode;
        }else{
            self.driView.hidden = YES;
            self.accBtn.enabled = !_certCode.length;
            self.addBtn.enabled = !_certCode.length;
            self.fie1.userInteractionEnabled = !_certCode.length;
        }
    }
}

- (void)setModelInfo:(DetailModel *)modelInfo{
    if (modelInfo) {
        _modelInfo = modelInfo;
        self.titleFie.text = _modelInfo.title;
        self.titleFie.userInteractionEnabled = !self.editId;
        self.ptLab.text = _modelInfo.weight;
        [self.btn setTitle:_modelInfo.categoryTitle forState:UIControlStateNormal];
        switch (self.refresh) {
            case 1:
                [self customFieFirstWith:self.titleFie];
                break;
            case 2:
                [self customFieFirstWith:self.fie1];
                break;
            case 3:
                [self customFieFirstWith:self.handFie];
                break;
            default:
                break;
        }
    }
}

- (void)customFieFirstWith:(UITextField *)fie{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [fie becomeFirstResponder];
    });
}

- (void)setMessArr:(NSString *)messArr{
    if (messArr) {
        _messArr = messArr;
        self.fie1.text = _messArr;
    }
}

- (void)setHandSize:(NSString *)handSize{
    if (handSize) {
        _handSize = handSize;
        if (_handSize.length>0&&![_handSize isEqualToString:@"0"]) {
            self.handFie.text = _handSize;
        }
    }
}

@end
