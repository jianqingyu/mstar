//
//  MainTabViewController.m
//  MillenniumStar08.07
//
//  Created by yjq on 15/8/7.
//  Copyright (c) 2015年 qxzx.com. All rights reserved.
//

#import "MainTabViewController.h"
#import "MainNavViewController.h"
#import "InformationVC.h"
#import "HelpMenuVC.h"
#import "EditUserInfoVC.h"
#import "LoginViewController.h"
#import "HomePageVC.h"
#import "NetworkDetermineTool.h"
@interface MainTabViewController ()<UITabBarControllerDelegate>{
    InformationVC *infoVC;
    HomePageVC *homePage;
}

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    homePage = [[HomePageVC alloc]init];
    [self addChildVcWithVC:homePage Title:@"首页"imageName:@"icon_ho" selectImage:@"icon_ho2"];
    
    infoVC = [[InformationVC alloc]init];
    [self addChildVcWithVC:infoVC Title:@"信息" imageName:@"icon_lw" selectImage:@"icon_lw2"];
    
//    HelpMenuVC *helpVC = [[HelpMenuVC alloc]init];
//    [self addChildVcWithVC:helpVC Title:@"帮助" imageName:@"icon_bz_s" selectImage:@"icon_bz"];
    
    EditUserInfoVC *infoVc = [EditUserInfoVC new];
    [self addChildVcWithVC:infoVc Title:@"我的" imageName:@"icon_set" selectImage:@"icon_set2"];
    [self.tabBar setBarTintColor:CUSTOM_COLOR(245, 245, 247)];
}

- (void)addChildVcWithVC:(UIViewController *)vc Title:(NSString *)title
            imageName:(NSString *)imageName selectImage:(NSString *)selectImage{
    vc.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:imageName]imageWithRenderingMode:
        UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *selectDict = [NSMutableDictionary dictionary];
    selectDict[NSForegroundColorAttributeName] = CUSTOM_COLOR(246, 55, 43);
    selectDict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:12];
    [vc.tabBarItem setTitleTextAttributes:selectDict forState:UIControlStateSelected];
    
    NSMutableDictionary *norDict = [NSMutableDictionary dictionary];
    norDict[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    norDict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:12];
    [vc.tabBarItem setTitleTextAttributes:norDict forState:UIControlStateNormal];
    
    MainNavViewController *nav = [[MainNavViewController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change
//                       context:(void *)context{
//    if([keyPath isEqualToString:@"tabCount"]){
//        if (homePage.tabCount!=0){
//            infoVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",homePage.tabCount];
//        }else{
//            infoVC.tabBarItem.badgeValue = nil;
//        }
//    }
//}

//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    if (![NetworkDetermineTool isExistenceNet]) {
//        [NetworkDetermineTool changeSupNaviWithNav:(MainNavViewController *)viewController];
//    }
//    return YES;
//}
- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

@end
