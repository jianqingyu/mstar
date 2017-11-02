//
//  AppDownViewC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/8.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "AppDownViewC.h"

@interface AppDownViewC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *codeImg;
@property (weak, nonatomic) IBOutlet UIImageView *codeAndroidImg;
@property (nonatomic, copy) NSDictionary *iOSDic;
@property (nonatomic, copy) NSDictionary *androidDic;
@property (weak, nonatomic) IBOutlet UIScrollView *backScr;
@end

@implementation AppDownViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"版本详情";
    self.iOSDic = @{@"image":@"mStar",@"url":
              @"https://itunes.apple.com/cn/app/千禧之星珠宝/id1227342902?mt=8"};
    self.androidDic = @{@"image":@"mStar2",@"url":
             @"https://itunes.apple.com/cn/app/千禧之星珠宝2/id1244977034?mt=8"};
//    self.androidDic = @{@"image":@"android",@"url":@"https://www.pgyer.com/IGab"};
    self.codeImg.image = [UIImage imageNamed:self.iOSDic[@"image"]];
    self.codeAndroidImg.image = [UIImage imageNamed:self.androidDic[@"image"]];
    self.backScr.contentSize = CGSizeMake(240, 460);
}

- (IBAction)btnClick:(id)sender {
    NSString *str = [self.iOSDic[@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:str]];
    application = nil;
}

- (IBAction)androidClick:(id)sender {
    NSString *str = [self.androidDic[@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:str]];
    application = nil;
}

@end
