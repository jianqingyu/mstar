//
//  OrderListTableCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/10/26.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "OrderListTableCell.h"
@interface OrderListTableCell()
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *staueLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *upDateLab;
@property (weak, nonatomic) IBOutlet UILabel *editDateLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *totlePriceLab;
@property (weak, nonatomic) IBOutlet UILabel *orderLab;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *shopImages;
@end

@implementation OrderListTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"orderListCell";
    OrderListTableCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[OrderListTableCell alloc]initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"OrderListTableCell" owner:nil options:nil][0];
        for (UIImageView *imgView in self.shopImages) {
            [imgView setLayerWithW:0.001  andColor:DefaultColor andBackW:1];
        }
    }
    return self;
}

- (void)setListInfo:(OrderListNewInfo *)listInfo{
    if (listInfo) {
        _listInfo = listInfo;
        self.numLab.text = _listInfo.orderNum;
        self.nameLab.text = _listInfo.customerName;
        self.upDateLab.text = _listInfo.orderDate;
        if (_listInfo.modifyDate.length>0) {
            self.editDateLab.text = _listInfo.modifyDate;
        }
        if (_listInfo.confirmDate.length>0) {
            self.orderLab.text = @"审核日期：";
            self.editDateLab.text = _listInfo.confirmDate;
        }
        self.detailLab.text = _listInfo.otherInfo;
        self.staueLab.text = _listInfo.orderStatusTitle;
        
        self.totlePriceLab.text = [OrderNumTool strWithPrice:_listInfo.totalPrice];
        self.priceLab.text = [OrderNumTool strWithPrice:_listInfo.needPayPrice];
        for (int i=0; i<_listInfo.pics.count; i++) {
            if (i>3) {
                return;
            }
            UIImageView *imageView = self.shopImages[i];
            imageView.hidden = NO;
            [imageView sd_setImageWithURL:[NSURL URLWithString:_listInfo.pics[i]] placeholderImage:DefaultImage];
        }
    }
}

@end
