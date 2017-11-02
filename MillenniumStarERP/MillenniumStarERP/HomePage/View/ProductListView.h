//
//  ProductListView.h
//  MillenniumStar
//
//  Created by ❥°澜枫_ on 15/5/18.
//  Copyright (c) 2015年 Millennium Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductInfo.h"

@protocol productItemClickDelegate <NSObject>

- (void)productItemClickWith:(int)index;

@end

@interface ProductListView : UIView

@property (nonatomic, assign) id<productItemClickDelegate>delegate;
@property (retain, nonatomic) IBOutlet UIImageView *bg;
@property (retain, nonatomic) IBOutlet UIImageView *headImage;
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UILabel *officialPrice;
@property (retain, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (retain, nonatomic) ProductInfo *proInfo;
@property (weak, nonatomic) IBOutlet UIView *topbackView;
@property (weak, nonatomic) IBOutlet UIView *priceView;
- (IBAction)tapGesture:(id)sender;
+ (ProductListView*)shareListView;

//数据更新
- (void)updateDevInfoWith:(NSMutableArray*)devInfoArray index:(int)index;
//- (void)updateNakedDrillWith:(NSMutableArray*)devInfoArray index:(int)index;
@end
