//
//  DeliveryOrderTableCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/3.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "DeliveryOrderTableCell.h"
@interface DeliveryOrderTableCell()
@property (nonatomic,strong)UIView *imgView;
@property (nonatomic,strong)UIView *labView;
@property (nonatomic,strong)UIView *labViews;
@property (nonatomic,weak)UILabel *titleLab;
@property (nonatomic,weak)UILabel *priceLab;
@property (nonatomic,weak)UILabel *detailLab;
@property (nonatomic,weak)UIImageView *imageV;
@property (nonatomic,weak)UILabel *detailLab2;
@property (nonatomic,weak)UILabel *detailLab3;
@property (nonatomic,weak)UILabel *detailLab4;
@end

@implementation DeliveryOrderTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"DeliveryCell";
    DeliveryOrderTableCell *tableCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (tableCell==nil) {
        tableCell = [[DeliveryOrderTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return tableCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatImageView];
    }
    return self;
}

- (UILabel *)LabWithFont:(CGFloat)font andColor:(UIColor *)color{
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.font = [UIFont systemFontOfSize:font];
    titleLab.textColor = color;
    [self addSubview:titleLab];
    return titleLab;
}

- (UILabel *)Lab:(CGFloat)font Color:(UIColor *)color andSup:(UIView *)supView{
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.font = [UIFont systemFontOfSize:font];
    titleLab.textColor = color;
    [supView addSubview:titleLab];
    return titleLab;
}

- (void)creatImageView{
    self.titleLab = [self LabWithFont:16 andColor:[UIColor darkGrayColor]];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(@20);
    }];
    
    self.priceLab = [self LabWithFont:16 andColor:[UIColor redColor]];
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(@20);
    }];
    
    UILabel *lab = [self LabWithFont:16 andColor:[UIColor darkGrayColor]];
    lab.text = @"成本：";
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLab.mas_left).with.offset(0);
        make.top.equalTo(self).offset(10);
        make.height.mas_equalTo(@20);
    }];
    
    //文字视图
    self.labView = [[UIView alloc]init];
    [self addSubview:self.labView];
    [self.labView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).with.offset(15);
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-15);
        make.right.equalTo(self).offset(-15);
    }];
    
    self.detailLab = [self Lab:14 Color:[UIColor lightGrayColor] andSup:self.labView];
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labView).offset(0);
        make.left.equalTo(self.labView).offset(0);
    }];
    
    UIImageView *imgLog = [[UIImageView alloc]init];
    imgLog.image = [UIImage imageNamed:@"icon_down"];
    [self.labView addSubview:imgLog];
    [imgLog mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.labView).offset(0);
        make.right.equalTo(self.labView).offset(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    //图片列表
    self.imgView = [[UIView alloc]init];
    [self addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).with.offset(15);
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-15);
        make.right.equalTo(self).offset(-15);
    }];
    
    UIImageView *image = [[UIImageView alloc]init];
    [self.imgView addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView).offset(0);
        make.top.equalTo(self.imgView).offset(0);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    self.imageV = image;
    
    self.detailLab2 = [self Lab:14 Color:[UIColor lightGrayColor] andSup:self.imgView];
    [self.detailLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView).with.offset(0);
        make.left.equalTo(self.imageV.mas_right).with.offset(3);
        make.right.equalTo(self.imgView).offset(-10);
    }];
    
    //文字列表
    self.labViews = [[UIView alloc]init];
    [self.imgView addSubview:self.labViews];
    [self.labViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLab2.mas_bottom).with.offset(3);
        make.left.equalTo(self.imageV.mas_right).with.offset(3);
        make.height.mas_equalTo(@0);
        make.right.equalTo(self.imgView).offset(-10);
    }];
    
    self.detailLab3 = [self Lab:14 Color:[UIColor lightGrayColor] andSup:self.imgView];
    self.detailLab3.numberOfLines = 0;
    [self.detailLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labViews.mas_bottom).with.offset(3);
        make.left.equalTo(self.imageV.mas_right).with.offset(3);
        make.right.equalTo(self.imgView).offset(-10);
    }];
    
    self.detailLab4 = [self Lab:14 Color:[UIColor lightGrayColor] andSup:self.imgView];
    self.detailLab4.numberOfLines = 0;
    [self.detailLab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLab3.mas_bottom).with.offset(3);
        make.left.equalTo(self.imageV.mas_right).with.offset(3);
        make.right.equalTo(self.imgView).offset(-10);
    }];
    
    UIImageView *imgLog2 = [[UIImageView alloc]init];
    imgLog2.image = [UIImage imageNamed:@"icon_up"];
    [self.imgView addSubview:imgLog2];
    [imgLog2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imgView).offset(0);
        make.right.equalTo(self.imgView).offset(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)setDeliveryInfo:(DeliveryListInfo *)deliveryInfo{
    if (deliveryInfo) {
        _deliveryInfo = deliveryInfo;
        self.labView.hidden = _deliveryInfo.isOpen;
        self.imgView.hidden = !_deliveryInfo.isOpen;
        NSString *title = [NSString stringWithFormat:@"%@ %@ %@",_deliveryInfo.modNum,_deliveryInfo.typeName,_deliveryInfo.modelNum];
        self.titleLab.text = title;
        
        self.priceLab.text = [OrderNumTool strWithPrice:_deliveryInfo.unitPrice];
        self.detailLab.text = _deliveryInfo.sInfo;
        self.detailLab2.text = _deliveryInfo.sInfo;
        self.detailLab3.text = _deliveryInfo.dInfo;
        self.detailLab4.text = _deliveryInfo.remark;
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:_deliveryInfo.pic] placeholderImage:DefaultImage];
        
        [UIView animateWithDuration:0.1 animations:^{
            [self.labViews.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }];
        [self.labViews mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_deliveryInfo.stInfo.count*20);
        }];
        if (_deliveryInfo.stInfo.count>0) {
            for (int i=0; i<_deliveryInfo.stInfo.count; i++) {
                UILabel *lab = [self Lab:14 Color:[UIColor lightGrayColor] andSup:self.labViews];
                [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.labViews).offset(i*20);
                    make.left.equalTo(self.labViews).with.offset(0);
                    make.right.equalTo(self.labViews).offset(0);
                    make.height.mas_equalTo(@17);
                }];
                lab.text = _deliveryInfo.stInfo[i];
            }
        }
    }
}

@end
