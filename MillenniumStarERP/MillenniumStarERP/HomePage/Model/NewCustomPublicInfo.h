//
//  NewCustomPublicInfo.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/5/18.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewCustomPublicInfo : NSObject
@property (nonatomic,  copy)NSArray *imgArr;    // 顶部图片
@property (nonatomic,  copy)NSArray *chooseArr;  // 部件数据
@property (nonatomic,  copy)NSArray *handSizeArr; //手寸信息
@property (nonatomic,  copy)NSArray *numberArr; //数量信息
@property (nonatomic,  copy)NSString *handSize;  //手寸
@property (nonatomic,strong)NSMutableArray *baseArr;   // 定制数据
@property (nonatomic,strong)NSMutableArray *searchPids; //选择条件
@property (nonatomic,strong)NSDictionary *netData; //网络请求数据
@property (nonatomic,strong)NSDictionary *modelItem; //订单信息
@property (nonatomic,strong)NSDictionary *driData; //裸钻信息
+ (instancetype)shared;
- (void)loadHomeData:(void(^)(void))callBack;
- (void)loadDefalutData:(void(^)(void))callBack;
- (void)searchCusData:(int)index andBack:(void(^)(void))callBack;
- (void)confirmData:(void(^)(id model))callBack;
- (BOOL)chooseLitleData:(NSDictionary *)dic;
- (void)changeDriInfo:(NSDictionary *)driDic;

@end
