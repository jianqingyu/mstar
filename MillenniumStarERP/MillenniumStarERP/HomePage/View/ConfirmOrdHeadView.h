//
//  ConfirmOrdHeadView.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressInfo.h"
#import "OrderNewInfo.h"
@class ConfirmOrdHeadView;
//1.定义协议 命名:类名+Delegate
@protocol ConfirmOrdHeadViewDelegate <NSObject>
//方法的参数:第一参数是委托方自己,后面的参数可以为委托方发给代理方的辅助信息
- (void)btnClick:(ConfirmOrdHeadView *)headView
        andIndex:(NSInteger)index andMes:(NSString *)mes;
@end

@interface ConfirmOrdHeadView : UIView
+ (ConfirmOrdHeadView *)view;
@property (weak, nonatomic) IBOutlet UITextField *customerFie;
@property (weak, nonatomic) IBOutlet UITextField *wordFie;
@property (weak, nonatomic) IBOutlet UITextField *noteFie;
@property (weak, nonatomic) id<ConfirmOrdHeadViewDelegate> delegate;
@property (nonatomic,strong)AddressInfo *addInfo;
@property (nonatomic,strong)OrderNewInfo *orderInfo;
@property (nonatomic,  copy)NSString *qualityMes;
@property (nonatomic,  copy)NSString *colorMes;
@property (nonatomic,  copy)NSString *invoMes;
@end
