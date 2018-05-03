//
//  CommonUsedTool.m
//  MillenniumStarERP
//
//  Created by yjq on 17/2/21.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "CommonUsedTool.h"

@implementation CommonUsedTool
+ (void)loadUpDate:(void (^)(NSDictionary *response, NSError *error))callback
             image:(UIImage *)image Dic:(NSMutableDictionary *)params
               Url:(NSString *)url {
    //1.请求管理者对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                     @"application/json",
                                                     @"text/html",
                                                     @"image/jpeg",
                                                     @"image/png",
                                                     @"application/octet-stream",
                                                     @"text/json",
                                                     nil];
    //2.拼接参数
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    //3.发送请求
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:data name:@"attachment" fileName:fileName mimeType:@"image/jpg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD showSuccess:responseObject[@"message"]];
        if (callback) {
            callback(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"保存头像失败"];
        if (callback) {
            callback(nil,error);
        }
    }];
    //老方法废弃了
//    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        NSData *data = UIImageJPEGRepresentation(image, 0.5);
//        [formData appendPartWithFileData:data name:@"attachment" fileName:fileName mimeType:@"image/jpg"];
//    } success:^(NSURLSessionDataTask *task, NSDictionary * responseObject) {
//        [MBProgressHUD showSuccess:responseObject[@"message"]];
//        if (callback) {
//            callback(responseObject,nil);
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [MBProgressHUD showError:@"保存头像失败"];
//        if (callback) {
//            callback(nil,error);
//        }
//    }];
}

@end
