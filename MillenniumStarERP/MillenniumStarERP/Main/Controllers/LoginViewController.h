//
//  LoginViewController.h
//  CityHousekeeper
//
//  Created by yjq on 15/11/18.
//  Copyright © 2015年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^noLoginBack)(BOOL isSel);
@interface LoginViewController : UIViewController
@property (nonatomic,assign)BOOL noLogin;
@property (nonatomic,  copy)noLoginBack back;
@end
