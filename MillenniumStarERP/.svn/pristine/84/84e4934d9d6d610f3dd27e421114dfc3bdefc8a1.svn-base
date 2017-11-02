//
//  CommonHeader.h
//  WiFiDisk
//
//  Created by tu changwei on 13-1-21.
//  Copyright (c) 2013年 tu changwei. All rights reserved.
//

#ifndef WiFiDisk_CommonHeader_h
#define WiFiDisk_CommonHeader_h

#define App [UIApplication sharedApplication]
#define Defs  [NSUserDefaults standardUserDefaults]
#define HomeDir [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

//<<<---  屏幕适配相关
#define IsPhone ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define iOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define DevWidth  (IsPhone ? [UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height)
#define DevHeight  (IsPhone ?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.width)
#define IS_6PLUS (IsPhone && [[UIScreen mainScreen] bounds].size.height >= 736.0)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

//<<<--- DataBase相关
#define DBPath [HomeDir stringByAppendingString:@"/Data.sqlite"]
#define DB [FMDatabase databaseWithPath:DBPath]
//--->>>

#define CURRENT_LANAGES  @"CURRENT_LANAGES"
#define SAVE_INFO_TO_LOCAL @"SAVE_INFO_TO_LOCAL"
#define STAY_SINGED_IN @"STAY_SINGED_IN"
#define USER_NAME @"USER_NAME"
#define PASSWORD @"PASSWORD"

#define LAUNCHIMG_SLEEP_TIME 1.0f
#define CHINESE @"zh-Hans"
#define ENGLISH @"en"
#define ECLocalizedString(key,mytable) [[ECLocalizableController bundle] localizedStringForKey:(key) value:(key) table:(mytable)]
#define MYTABLE @"InfoPlist"
#define kRequestTimeOutInterval 10
#define SERVER_REQUEST_ERROR 1000000
#define SHOWALERTVIEW(msg)   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];[alertView show];
#define DefaultColor [UIColor colorWithRed:240/255.0 green:238/255.0 blue:245/255.0 alpha:1]
#define RGBColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define HOSTNAME @"http://192.168.1.47:8082/App/"

//#define HOSTNAME @"http://211.162.71.165:8082/App/"  //外网地址
//#define HOSTNAME @"http://192.168.1.240:8083/App/"  //内网地址

//全国省市地址
//#define HOSTAddress @"http://192.168.1.240:8083/App/AreaAddress"
//#define HOSTAddress @"http://192.168.1.47:8082/App/AreaAddress"
/**选择地址通知名字*/
#define NotificationName @"NotificationChangeCity"
#define UserInfoName @"userinfoCityName"
/**管理地址通知*/
#define NotificationManagerName @"NotificationManagerCity"
#define UserInfoManagerName @"UserinfoManagerCityName"
//默认图片
#define DefaultImage  [UIImage imageNamed:@"image_default"]
//分页请求相关
#define DefaultPage  1
#define DefaultPageNum  10
#define DefaultOrderBy  @"sale_down"

#endif
