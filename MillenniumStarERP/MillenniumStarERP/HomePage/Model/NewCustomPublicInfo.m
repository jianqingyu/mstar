//
//  NewCustomPublicInfo.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/5/18.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "NewCustomPublicInfo.h"
#import "StrWithIntTool.h"
#import "CustomJewelInfo.h"
#import "NewCustomizationInfo.h"
@implementation NewCustomPublicInfo
//单例
+ (instancetype)shared
{
    static dispatch_once_t once = 0;
    static NewCustomPublicInfo *alert;
    dispatch_once(&once, ^{
        alert = [[NewCustomPublicInfo alloc]init];
    });
    return alert;
}
#pragma mark -- 网络请求
- (void)loadHomeData:(void(^)(void))callBack{
    [SVProgressHUD show];
    self.baseArr = @[].mutableCopy;
    self.searchPids = @[].mutableCopy;
    int type = [self.netData[@"isEd"]intValue];
    NSString *detail;
    if (type==1) {
        detail = @"CustomDetailPageForCurrentOrderEditPage";
    }else if (type==2){
        detail = @"CustomDetailPageForWaitCheckEditPage";
    }else{
        detail = @"CreateCustomItem";
    }
    NSString *netUrl = [NSString stringWithFormat:@"%@%@",baseUrl,detail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    if ([self.netData[@"proId"] length]>0) {
        params[@"itemId"] = self.netData[@"proId"];
    }
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [self setNewCustomDataWith:response.data and:NO];
            if (callBack) {
                callBack();
            }
        }
    } requestURL:netUrl params:params];
}
//删除单个部件返回数据
- (void)loadDefalutData:(void (^)(void))callBack{
    [SVProgressHUD show];
    NSString *detail = @"CustomDetailPageForGetSelectReturnPage";
    NSString *netUrl = [NSString stringWithFormat:@"%@%@",baseUrl,detail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    if ([self.netData[@"proId"] length]>0) {
        params[@"itemId"] = self.netData[@"proId"];
    }
    params[@"selectPids"] = [StrWithIntTool strWithArr:self.searchPids With:@","];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [self setNewCustomDataWith:response.data and:YES];
            if (callBack) {
                callBack();
            }
        }
    } requestURL:netUrl params:params];
}

- (void)setNewCustomDataWith:(NSDictionary *)dic and:(BOOL)isDelete{
    if ([YQObjectBool boolForObject:dic[@"modelItem"]]) {
        if ([dic[@"modelItem"][@"handSize"]length]>0) {
            self.handSize = dic[@"modelItem"][@"handSize"];
        }
        self.modelItem = dic[@"modelItem"];
        [self setupImgArrData];
        if ([YQObjectBool boolForObject:dic[@"modelParts"]]) {
            NSArray *arr = [NewCustomizationInfo mj_objectArrayWithKeyValuesArray:
                            dic[@"modelParts"]];
            self.baseArr = arr.mutableCopy;
            if (!isDelete) {
                for (NewCustomizationInfo *info in arr) {
                    if ([dic[@"modelItem"][@"id"] intValue]>0) {
                        [self.searchPids addObject:info.pid];
                    }else{
                        [self.searchPids addObject:@""];
                    }
                }
            }
        }
    }
    if ([YQObjectBool boolForObject:dic[@"jewelStone"]]) {
        [self addStoneWithDic:dic[@"jewelStone"]];
    }else{
        NSMutableDictionary *driData = @{}.mutableCopy;
        driData[@"info"] = @"选择裸钻";
        driData[@"codeId"] = @"";
        driData[@"price"] = @"";
        self.driData = driData;
    }
    if ([YQObjectBool boolForObject:dic[@"modelpartCount"]]) {
        self.numberArr = dic[@"modelpartCount"];
    }
    if ([YQObjectBool boolForObject:dic[@"handSizeData"]]) {
        NSMutableArray *mutA = [NSMutableArray new];
        for (NSString *title in dic[@"handSizeData"]) {
            [mutA addObject:@{@"title":title}];
        }
        self.handSizeArr = mutA.copy;
    }
}

- (void)changeDriInfo:(NSDictionary *)driDic{
    [self setDefalutCustomViewWith:driDic[@"driArr"] andId:driDic[@"infoId"] andInfo:driDic[@"price"]];
}

- (void)addStoneWithDic:(NSDictionary *)data{
    CustomJewelInfo *CusInfo = [CustomJewelInfo mj_objectWithKeyValues:data];
    NSArray *infoArr = @[@"钻石",CusInfo.jewelStoneWeight,CusInfo.jewelStoneShape,
                         CusInfo.jewelStoneColor,CusInfo.jewelStonePurity,
                         CusInfo.jewelStoneCode];
    [self setDefalutCustomViewWith:infoArr andId:CusInfo.jewelStoneId
                           andInfo:CusInfo.jewelStonePrice];
}

- (void)setDefalutCustomViewWith:(NSArray *)infoArr
                           andId:(NSString *)codeId
                         andInfo:(NSString *)price{
    NSArray *type = @[@"类型:",@"重量:",@"形状:",@"颜色:",@"净度:",@"证书号:"];
    NSMutableArray *mutA = @[].mutableCopy;
    for (int i=0; i<infoArr.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%@%@",type[i],infoArr[i]];
        [mutA addObject:str];
    }
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    mutDic[@"info"] = [StrWithIntTool strWithArr:mutA With:@","];
    mutDic[@"codeId"] = codeId;
    mutDic[@"price"] = price;
    self.driData = mutDic.copy;
}
//搜索部件
- (void)searchCusData:(int)index andBack:(void (^)(void))callBack{
    [SVProgressHUD show];
    NewCustomizationInfo *info = self.baseArr[index];
    NSString *detail = @"CustomPartsList";
    NSString *netUrl = [NSString stringWithFormat:@"%@%@",baseUrl,detail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"partSort"] = info.partSort;
    params[@"selectPids"] = [StrWithIntTool strWithArr:self.searchPids With:@","];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"list"]]) {
                self.chooseArr = [NewCustomizationInfo
                                mj_objectArrayWithKeyValuesArray:response.data[@"list"]];
                if (callBack) {
                    callBack();
                }
            }
        }
    } requestURL:netUrl params:params];
}
#pragma mark - 初始化图片
- (void)setupImgArrData{
    NSArray *picArr = self.modelItem[@"modelPic"];
    NSMutableArray *pic  = @[].mutableCopy;
    NSMutableArray *mPic = @[].mutableCopy;
    NSMutableArray *bPic = @[].mutableCopy;
    for (NSDictionary*dict in picArr) {
        NSString *str = [self UsingEncoding:dict[@"pic"]];
        if (str.length>0) {
            [pic addObject:str];
        }
        NSString *strm = [self UsingEncoding:dict[@"picm"]];
        if (strm.length>0) {
            [mPic addObject:strm];
        }
        NSString *strb = [self UsingEncoding:dict[@"picb"]];
        if (strb.length>0) {
            [bPic addObject:strb];
        }
    }
    NSArray *headArr;
    if (mPic.count==0) {
        mPic = @[@"picm"].mutableCopy;
    }
    if (IsPhone) {
        headArr = mPic.copy;
    }else{
        headArr = bPic.copy;
    }
    self.imgArr = headArr;
}

- (NSString *)UsingEncoding:(NSString *)str{
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)chooseLitleData:(NSDictionary *)dic{
    if ([dic[@"stoneWeightRange"][@"value"]length]!=0&&![dic[@"stoneWeightRange"][@"value"] isEqualToString:self.modelItem[@"stoneWeightRange"][@"value"]]) {
        NSMutableDictionary *mutD = @{}.mutableCopy;
        self.driData = mutD.copy;
    }
    if (![self.modelItem[@"id"]isEqualToString:dic[@"id"]]) {
        self.modelItem = dic;
        [self setupImgArrData];
        return YES;
    }
    return NO;
}

- (void)confirmData:(void (^)(id model))callBack{
    [SVProgressHUD show];
    int type = [self.netData[@"isEd"]intValue];
    NSString *detail;
    if (type==1) {
        detail = @"OrderCurrentEditModelItemForCustomDo";
    }else if (type==2){
        detail = @"CustomDetailPageForWaitCheckEditDo";
    }else{
        detail = @"OrderCurrentDoModelItemForCustomDo";
    }
    NSString *netUrl = [NSString stringWithFormat:@"%@%@",baseUrl,detail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"productId"] = self.modelItem[@"id"];
    params[@"handSize"] = self.handSize;
    params[@"number"] = @1;
    params[@"jewelStoneId"] = self.driData[@"codeId"];
    if (type) {
        params[@"itemId"] = self.netData[@"proId"];
    }
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if (callBack) {
                callBack(response.data);
            }
        }else{
            [MBProgressHUD showError:response.message];
        }
    } requestURL:netUrl params:params];
}

@end
