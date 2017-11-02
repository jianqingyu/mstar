//
//  InformationCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/7.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "InformationCell.h"
@interface InformationCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@end
@implementation InformationCell

+ (InformationCell *)cellWithTableView:(UITableView*)tableView{
    static NSString *ID = @"informationCell";
    InformationCell *userCell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (userCell==nil) {
        userCell = [[InformationCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        userCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return userCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"InformationCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setMessInfo:(MessageInfo *)messInfo{
    if (messInfo) {
        _messInfo = messInfo;
        self.titleLab.text = _messInfo.title;
        self.detailLab.text = _messInfo.detail;
        self.dateLab.text = _messInfo.createDate;
    }
}

@end
