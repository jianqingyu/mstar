//
//  NakedDriConfirmHeadV.h
//  MillenniumStarERP
//
//  Created by yjq on 17/6/2.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressInfo.h"
@class NakedDriConfirmHeadV;
//1.定义协议 命名:类名+Delegate
@protocol NakedDriConfirmHeadVDelegate <NSObject>
//方法的参数:第一参数是委托方自己,后面的参数可以为委托方发给代理方的辅助信息
- (void)btnClick:(NakedDriConfirmHeadV *)headView
        andIndex:(NSInteger)index andMes:(NSString *)mes;
@end
@interface NakedDriConfirmHeadV : UIView
@property (weak, nonatomic) IBOutlet UITextField *noteLab;
@property (weak, nonatomic) IBOutlet UITextField *customFie;
@property (weak, nonatomic) IBOutlet UIView *bottomV;
@property (weak, nonatomic) IBOutlet UIView *noteView;
@property (weak, nonatomic) id<NakedDriConfirmHeadVDelegate> delegate;
@property (nonatomic,strong)AddressInfo *addInfo;
@property (nonatomic,  copy)NSString *invoMes;
@end
