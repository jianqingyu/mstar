//
//  ProgressListCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/12/20.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ProgressListCell.h"
#import "ProgressListView.h"
@interface ProgressListCell ()
@property (weak,nonatomic) IBOutlet UIProgressView *progressOne;
@property (nonatomic,weak)UIImageView *imageV;
@property (nonatomic,weak)UILabel *titleL;
@property (nonatomic,weak)UILabel *otherL;
@property (nonatomic,weak)UILabel *numL;
@property (nonatomic,strong)UIView *footView;
@end

@implementation ProgressListCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    ProgressListCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[ProgressListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatImageView];
    }
    return self;
}

- (void)creatImageView{
    UIImageView *image = [[UIImageView alloc]init];
    [self addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    self.imageV = image;
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textColor = [UIColor blackColor];
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image.mas_right).with.offset(15);
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(@20);
    }];
    self.titleL = titleLab;
    
    UILabel *otherLab = [[UILabel alloc]init];
    otherLab.font = [UIFont systemFontOfSize:15];
    otherLab.textColor = [UIColor darkGrayColor];
    [self addSubview:otherLab];
    [otherLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image.mas_right).with.offset(15);
        make.top.equalTo(titleLab.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@18);
    }];
    self.otherL = otherLab;
    
    UILabel *numlab = [[UILabel alloc]init];
    numlab.font = [UIFont systemFontOfSize:15];
    numlab.textColor = [UIColor blackColor];
    [self addSubview:numlab];
    [numlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image.mas_right).with.offset(15);
        make.top.equalTo(otherLab.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@18);
    }];
    self.numL = numlab;
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = DefaultColor;
    line.hidden = YES;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(image.mas_bottom).with.offset(9);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(@1);
    }];
    
    self.footView = [[UIView alloc]init];
    [self addSubview:self.footView];
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.top.equalTo(line.mas_bottom).with.offset(0);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(0);
    }];
}

- (void)setProInfo:(ProgressListInfo *)proInfo{
    if (proInfo) {
        _proInfo = proInfo;
        [UIView animateWithDuration:0.1 animations:^{
            [self.footView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }];
        
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:_proInfo.pic] placeholderImage:DefaultImage];
        self.titleL.text = _proInfo.title;
        self.otherL.text = _proInfo.modelInfo;
        self.numL.text = [NSString stringWithFormat:@"%@件",_proInfo.number];
        if (_proInfo.progress.count==0) {
            return;
        }
        for (int i=0; i<_proInfo.progress.count; i++) {
            NSDictionary *dict = _proInfo.progress[i];
            CGFloat topF = i*(proHeight+proMar);
            ProgressListView *listV = [[ProgressListView alloc]initWithFrame:CGRectZero];
            [self.footView addSubview:listV];
            [listV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.footView).offset(0);
                make.top.equalTo(self.footView).offset(topF);
                make.right.equalTo(self.footView).offset(0);
                make.height.mas_equalTo(proHeight);
            }];
            float pro = ([dict[@"currentFlow"]floatValue])/self.totalNum;
            listV.progress = pro;
            listV.titleLab.text = dict[@"flowInfo"];
        }
    }
}

@end
