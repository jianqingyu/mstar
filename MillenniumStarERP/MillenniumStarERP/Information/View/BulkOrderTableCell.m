//
//  BulkOrderTableCell.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/3/27.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "BulkOrderTableCell.h"
#import "KeyBoardView.h"
@interface BulkOrderTableCell()<UITextFieldDelegate,KeyBoardViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *driNum;
@property (weak, nonatomic) IBOutlet UITextField *number;
@property (weak, nonatomic) IBOutlet UITextField *color;
@property (weak, nonatomic) IBOutlet UITextField *handFie;
@property (weak, nonatomic) IBOutlet UILabel *remindLab;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@end
@implementation BulkOrderTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    BulkOrderTableCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[BulkOrderTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"BulkOrderTableCell" owner:nil options:nil][0];
        self.driNum.tag = 311;
        self.number.tag = 312;
        self.color.tag  = 313;
        self.handFie.tag = 314;
        [self setSearchFieKeyBoard];
    }
    return self;
}

- (void)setSearchFieKeyBoard{
    self.driNum.inputView = nil;
    KeyBoardView * KBView = [[KeyBoardView alloc]init];
    KBView.delegate = self;
    self.driNum.inputView = KBView;
    KBView.inputSource = self.driNum;
}

- (void)btnClick:(KeyBoardView *)headView andIndex:(NSInteger)index{
    if (index==201) {
        self.driNum.inputView = nil;
        [self.driNum reloadInputViews];
    }else{
        [self.driNum resignFirstResponder];
    }
}

- (void)loadSearchProduct:(NSString *)search{
    if ([self.info.modelNum isEqualToString:search]) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@ModelDetailPageGetInfoByModelNum",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"modelNum"] = search;
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0&&[YQObjectBool boolForObject:response.data]) {
            self.info.modelNum = search;
        }else{
            [MBProgressHUD showError:response.message];
        }
        self.driNum.text = _info.modelNum;
    } requestURL:url params:params];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 311:
            [self loadSearchProduct:textField.text];
            break;
        case 312:
            self.info.number = textField.text;
            break;
        case 313:
            self.info.purity = textField.text;
            break;
        case 314:
            self.info.handSize = textField.text;
            break;
        default:
            break;
    }
}

- (void)setInfo:(BulkOrderInfo *)info{
    if (info) {
        _info = info;
        self.driNum.text = _info.modelNum;
        self.number.text = _info.number;
        self.color.text = _info.purity;
        self.handFie.text = _info.handSize;
        self.errorView.hidden = !_info.isErr;
        self.remindLab.text = _info.message;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _info.isErr = NO;
    _info.message = @"";
    self.errorView.hidden = YES;
}

@end
