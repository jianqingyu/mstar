//
//  NewBaseApi.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/3/15.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "NewBaseApi.h"
#import "RequestClient.h"
@implementation NewBaseApi
//自定义接口版本
#define ApiVersion @"2.0"

+ (instancetype)sharedBaseAPi{
    static NewBaseApi *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [NewBaseApi new];
    });
    return _sharedClient;
}

- (void)getGeneralRequestURL:(NSString*)requestURL
                      params:(NSMutableDictionary*)params{
    params[@"QxVersion"] = ApiVersion;
    [[RequestClient sharedClient] GET:requestURL parameters:params progress:nil success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        if ([responseObject[@"error"] intValue]==2) {
            [MBProgressHUD showError:@"需要登录"];
            [SVProgressHUD dismiss];
            return;
        }
        BaseResponse*result = [self resultWithDic:responseObject];
        [SVProgressHUD dismiss];
        [self didDelegate:result andEr:nil];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        [self didDelegate:nil andEr:error];
    }];
}

- (BaseResponse *)resultWithDic:(NSDictionary *)dic{
    BaseResponse*result = [[BaseResponse alloc]init];
    result.error = dic[@"error"];
    result.data = dic[@"data"];
    result.message = dic[@"message"];
    return result;
}

- (void)didDelegate:(BaseResponse *)response andEr:(NSError *)err{
    if ([self.delegate respondsToSelector:@selector(getGen:resData:andErr:)]) {
        [self.delegate getGen:self resData:response andErr:err];
    }
}

@end
