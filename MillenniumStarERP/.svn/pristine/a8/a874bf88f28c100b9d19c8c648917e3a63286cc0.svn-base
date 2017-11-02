//
//  NoNetViewController.m
//  MillenniumStar08.07
//
//  Created by yjq on 15/10/10.
//  Copyright © 2015年 qxzx.com. All rights reserved.
//

#import "NoNetViewController.h"

@interface NoNetViewController ()

@end

@implementation NoNetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"无网络连接";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:
            [UIImage imageNamed:@"icon_return"] style:UIBarButtonItemStyleDone
                                            target:self action:@selector(back)];
}

- (void)back{
    if (self.loadBack) {
        self.loadBack(YES);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
