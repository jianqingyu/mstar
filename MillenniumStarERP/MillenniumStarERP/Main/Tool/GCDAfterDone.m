//
//  GCDAfterDone.m
//  MillenniumStarERP
//
//  Created by yjq on 16/12/12.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "GCDAfterDone.h"

@implementation GCDAfterDone
//加载完所有任务执行
- (void)allSyncEnd{
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd.group", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        //只能同步操作
    });
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新UI
        });
    });
}

- (void)allASyncEnd{
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd.group", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    //在方法完成后调用 dispatch_group_leave(group);
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新UI
        });
    });
}

@end
