//
//  ProductListView.m
//  MillenniumStar
//
//  Created by ❥°澜枫_ on 15/5/18.
//  Copyright (c) 2015年 Millennium Star. All rights reserved.
//

#import "ProductListView.h"

@implementation ProductListView

+ (ProductListView*)shareListView
{
   return [[NSBundle mainBundle] loadNibNamed:@"ProductListView" owner:nil options:nil][0];
}
//数据更新
- (void)updateDevInfoWith:(NSMutableArray*)devInfoArray index:(int)index
{
    self.topbackView.backgroundColor = DefaultColor;
    self.tag = index;
    self.tapGesture.view.tag = index;

    if (index < devInfoArray.count)
    {
        self.proInfo = [devInfoArray objectAtIndex:index];
    }
    self.title.text = self.proInfo.title;
//    self.headImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:self.proInfo.pic] placeholderImage:DefaultImage];
    
    self.officialPrice.text = [OrderNumTool strWithPrice:self.proInfo.price];
}

- (IBAction)tapGesture:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    if ([self.delegate respondsToSelector:@selector(productItemClickWith:)]) {
        [self.delegate productItemClickWith:(int)tap.view.tag];
    }
}

@end
