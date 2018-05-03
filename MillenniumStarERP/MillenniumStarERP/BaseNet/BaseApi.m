//
//  BaseApi.m
//  MillenniumStar08.07
//
//  Created by rogers on 15-8-13.
//  Copyright (c) 2015年 qxzx.com. All rights reserved.
//

#import "BaseApi.h"
#import "OrderNumTool.h"
#import "RequestClient.h"
#import "ShowLoginViewTool.h"
#import "LoginViewController.h"
@implementation BaseApi
//自定义接口版本
#define ApiVersion @"2.2.1"
+ (void)getNoGeneralData:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL
                params:(NSMutableDictionary*)params{
    params[@"QxVersion"] = ApiVersion;
    [[RequestClient sharedClient]GET:requestURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseResponse*result = [self resultWithDic:responseObject];
        callback(result,nil);
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        if(callback){
            callback(nil,error);
        }
    }];
}
/*版本检查接口
 */
+ (void)getNewVerData:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL
               params:(NSMutableDictionary*)params{
    [[RequestClient sharedClient] GET:requestURL parameters:params progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        BaseResponse*result = [self resultWithDic:responseObject];
        callback(result,nil);
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        if(callback){
            callback(nil,error);
        }
    }];
}
/*通用GET接口弹出登录
 */
+ (void)getGeneralData:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL
                                             params:(NSMutableDictionary*)params{
    params[@"QxVersion"] = ApiVersion;
//    [OrderNumTool NSLoginWithStr:requestURL andDic:params];
    [[RequestClient sharedClient] GET:requestURL parameters:params progress:nil success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        if ([responseObject[@"error"] intValue]==2) {
            [MBProgressHUD showError:@"需要登录"];
            [self showLoginView:callback requestURL:requestURL params:params];
            [SVProgressHUD dismiss];
            return;
        }
        BaseResponse*result = [self resultWithDic:responseObject];
        callback(result,nil);
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        if(callback){
            callback(nil,error);
        }
    }];
}

+ (void)showLoginView:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL
               params:(NSMutableDictionary*)params{
    UIViewController *vc = [ShowLoginViewTool getCurrentVC];
    LoginViewController *login = [LoginViewController new];
    login.noLogin = YES;
    login.back = ^(BOOL isYes){
        params[@"tokenKey"] = [AccountTool account].tokenKey;
        [self getNoGeneralData:^(BaseResponse *response, NSError *error) {
            callback(response,nil);
        } requestURL:requestURL params:params];
    };
    [vc presentViewController:login animated:YES completion:nil];
}
/*通用POST接口
 */
+ (void)postGeneralData:(REQUEST_CALLBACK)callback requestURL:(NSString *)requestURL
                                            params:(id)params{
    requestURL = [NSString stringWithFormat:@"%@&QxVersion=%@",requestURL,ApiVersion];
//    params[@"QxVersion"] = ApiVersion;
    [[RequestClient sharedClient] POST:requestURL parameters:params progress:nil success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        BaseResponse*result = [self resultWithDic:responseObject];
        callback(result,nil);
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        if(callback){
            callback(nil,error);
        }
    }];
}
/*json格式POST接口
 */
+ (void)postJsonData:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL
              params:(id)params{
//        params[@"QxVersion"] = ApiVersion;
    requestURL = [NSString stringWithFormat:@"%@&QxVersion=%@",requestURL,ApiVersion];
    [[RequestClient sharedPostClient] POST:requestURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        BaseResponse*result = [self resultWithDic:responseObject];
        callback(result,nil);
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        if(callback){
            callback(nil,error);
        }
    }];
}

+ (BaseResponse *)resultWithDic:(NSDictionary *)dic{
    if (![YQObjectBool boolForObject:dic]) {
        return nil;
    }
    BaseResponse*result = [[BaseResponse alloc]init];
    result.error = [self setValueWith:dic[@"error"]];
    result.data = [self setValueWith:dic[@"data"]];
    result.message = [self setValueWith:dic[@"message"]];
    return result;
}

+ (id)setValueWith:(id)mess{
    if ([YQObjectBool boolForObject:mess]) {
        return mess;
    }else{
        return nil;
    }
}

//清楚队列
+ (void)cancelAllOperation{
    [[RequestClient sharedClient].operationQueue cancelAllOperations];
}

@end
