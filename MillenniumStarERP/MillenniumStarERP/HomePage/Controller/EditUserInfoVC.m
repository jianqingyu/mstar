//
//  EditUserInfoVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/7.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "EditUserInfoVC.h"
#import "AccountTool.h"
#import "OrderPassVC.h"
#import "AppDownViewC.h"
#import "CustomInvoice.h"
#import "EditAddressVC.h"
#import "EditPhoneNumVc.h"
#import "CommonUsedTool.h"
#import "MasterCountInfo.h"
#import "EditShowPriceVC.h"
#import "UserOrderListVC.h"
#import "SearchOrderVc.h"
#import "UserTodayGoldVC.h"
#import "ChooseAddressCusView.h"
#import <ShareSDK/ShareSDK.h>
#import "CustomInputPassView.h"
#import "LoginViewController.h"
#import "PassWordViewController.h"
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

@interface EditUserInfoVC ()<UITableViewDelegate,UITableViewDataSource,
                 UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,  copy)NSArray *textArr;
@property (nonatomic,  copy)NSString *url;
@property (nonatomic,  weak)UIView *baView;
@property (nonatomic,assign)CGFloat addHeight;
@property (nonatomic,  weak)CustomInputPassView *putView;
@property (nonatomic,  weak)ChooseAddressCusView *infoView;
@property (nonatomic,strong)NSMutableDictionary *mutDic;
@property (nonatomic,  copy)NSDictionary *shareDic;
@property (nonatomic,strong)MasterCountInfo *masterInfo;
@end

@implementation EditUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.addHeight = 270;
    self.mutDic = [NSMutableDictionary new];
    [self setBaseViewData];
}

- (void)setBaseViewData{
    self.textArr = @[@[@"用户名",@"修改头像"],
                     @[@"设置",@"修改密码",@"管理地址",@"清理缓存",@"订单审核",@"今日金价",@"我的订单"]];
//    self.textArr = @[@[@"用户名",@"修改头像"],
//                     @[@"设置",@"修改密码",@"管理地址",@"清理缓存",@"订单审核"]];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    // 9.0以上才有这个属性，针对ipad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0){
        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    
    [self creatloginOutView];
    
    CustomInputPassView *pass = [CustomInputPassView new];
    pass.hidden = YES;
    pass.clickBlock = ^(BOOL isYes){
        if (isYes) {
            self.putView.hidden = YES;
            EditShowPriceVC *priceVc = [EditShowPriceVC new];
            [self.navigationController pushViewController:priceVc animated:YES];
        }else{
            [MBProgressHUD showError:@"密码错误"];
        }
    };
    [self.view addSubview:pass];
    [pass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.putView = pass;
}

- (void)creatloginOutView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 100)];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat width = MIN(SDevWidth, SDevHeight)*0.8;
    cancelBtn.backgroundColor = MAIN_COLOR;
    [cancelBtn setLayerWithW:5 andColor:BordColor andBackW:0.0001];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [footView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(footView);
        make.size.mas_equalTo(CGSizeMake(width, 44));
    }];
    
    UILabel *lab = [UILabel new];
    lab.textColor = CUSTOM_COLOR(40, 40, 40);
    lab.font = [UIFont systemFontOfSize:14];
    lab.text = appVer;
    [footView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footView).offset(-10);
        make.bottom.equalTo(footView).offset(-3);
    }];
    self.tableView.tableFooterView = footView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadUserInfoData];
}

- (void)loadUserInfoData{
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@userModifyPage",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data]) {
                self.masterInfo = [MasterCountInfo mj_objectWithKeyValues:response.data];
                if ([YQObjectBool boolForObject:response.data[@"headPic"]]) {
                    self.url = response.data[@"headPic"];
                }
                if ([YQObjectBool boolForObject:response.data[@"userName"]]) {
                    self.mutDic[@"用户名"] = response.data[@"userName"];
                }
                if ([YQObjectBool boolForObject:response.data[@"phone"]]) {
                    self.mutDic[@"修改手机号码"] = response.data[@"phone"];
                }
                if ([YQObjectBool boolForObject:response.data[@"address"]]) {
                    self.mutDic[@"管理地址"] = response.data[@"address"];
                }
//                if ([YQObjectBool boolForObject:response.data[@"userArea"]]) {
//                    self.mutDic[@"修改区域"] = response.data[@"userArea"];
//                }
                [self.tableView reloadData];
            }
        }
    } requestURL:regiUrl params:params];
}

- (void)cancelClick{
    NSString *regiUrl = [NSString stringWithFormat:@"%@userLoginOutDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            params[@"userName"] = [AccountTool account].userName;
            params[@"password"] = [AccountTool account].password;
            params[@"phone"] = [AccountTool account].phone;
            params[@"tokenKey"] = @"";
            params[@"isNoShow"] = [AccountTool account].isNoShow;
            params[@"isNoDriShow"] = [AccountTool account].isNoDriShow;
            params[@"isNorm"] = [AccountTool account].isNorm;
            Account *account = [Account accountWithDict:params];
            //自定义类型存储用NSKeyedArchiver
            [AccountTool saveAccount:account];
            
            StorageDataTool *data = [StorageDataTool shared];
            data.addInfo = nil;
            data.cusInfo = nil;
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [[LoginViewController alloc]init];
        }else{
            [MBProgressHUD showError:@"操作失败"];
        }
    } requestURL:regiUrl params:params];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.textArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *list = self.textArr[section];
    return list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==1) {
        return 80;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableCell =  [tableView cellForRowAtIndexPath:indexPath];
    if (tableCell == nil){
        tableCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                           reuseIdentifier:@"myCell"];
        tableCell.textLabel.font = [UIFont systemFontOfSize:15];
        tableCell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        tableCell.detailTextLabel.numberOfLines = 2;
    }
    NSArray *arr = self.textArr[indexPath.section];
    NSString *key = arr[indexPath.row];
    tableCell.textLabel.text = key;
    NSString *detailStr = self.mutDic[key];
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row==0) {
                tableCell.accessoryType = UITableViewCellAccessoryNone;
            }else if(indexPath.row==1){
                UIImageView *imageView = [self creatImageView];
                tableCell.accessoryView = imageView;
            }
         }
            break;
        default:
            if (indexPath.row==5) {
                UISwitch *switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
                BOOL isOn = [[[NSUserDefaults standardUserDefaults]objectForKey:@"goldOn"]intValue];
                [switchBtn setOn:isOn];
                tableCell.accessoryView = switchBtn;
                [switchBtn addTarget:self action:@selector(goldClick:)
                    forControlEvents:UIControlEventTouchUpInside];
            }else if(indexPath.row==6){
                UISwitch *switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
                BOOL isOn = [[[NSUserDefaults standardUserDefaults]objectForKey:@"myOn"]intValue];
                [switchBtn setOn:isOn];
                tableCell.accessoryView = switchBtn;
                [switchBtn addTarget:self action:@selector(myClick:)
                    forControlEvents:UIControlEventTouchUpInside];
            }else{
                tableCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
    }
    tableCell.detailTextLabel.text = detailStr;
    return tableCell;
}

- (UIImageView *)creatImageView{
    CGFloat width = 70;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,width,width)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    //设置头像
    if (self.image) {
        imageView.image = self.image;
    }else{
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.url]placeholderImage:
                                              [UIImage imageNamed:@"head_nor"]];
    }
    [imageView setLayerWithW:35 andColor:[UIColor whiteColor] andBackW:3.0f];
    return imageView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row==1) {
                UITableViewCell *cell = [self tableView:tableView
                                  cellForRowAtIndexPath:indexPath];
                [self creatUIAlertView:cell];
            }
        }
            break;
        case 1:
            if (indexPath.row==0){
                self.putView.hidden = NO;
            }else if (indexPath.row==1){
                PassWordViewController *passVc = [[PassWordViewController alloc]init];
                passVc.title = @"修改密码";
                passVc.isForgot = NO;
                [self.navigationController pushViewController:passVc animated:YES];
            }else if(indexPath.row==2){
                EditAddressVC *addVc = [EditAddressVC new];
                [self.navigationController pushViewController:addVc animated:YES];
            }else if(indexPath.row==3){
                [self clearTmpPics];
            }else if(indexPath.row==4){
                OrderPassVC *orderList = [OrderPassVC new];
                [self.navigationController pushViewController:orderList animated:YES];
            }else if(indexPath.row==5){
                UserTodayGoldVC *gold = [UserTodayGoldVC new];
                [self.navigationController pushViewController:gold animated:YES];
            }else{
                SearchOrderVc *seaVc = [SearchOrderVc new];
                [self.navigationController pushViewController:seaVc animated:YES];
            }
            break;
        default:
            break;
    }
}

- (void)goldClick:(UISwitch *)btn{
    [[NSUserDefaults standardUserDefaults]setObject:@(btn.on) forKey:@"goldOn"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)myClick:(UISwitch *)btn{
    [[NSUserDefaults standardUserDefaults]setObject:@(btn.on) forKey:@"myOn"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
//- (void)creatAddView{
//    UIView *bView = [UIView new];
//    bView.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
//    bView.hidden = YES;
//    [self.view addSubview:bView];
//    [bView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(0);
//        make.left.equalTo(self.view).offset(0);
//        make.right.equalTo(self.view).offset(0);
//        make.bottom.equalTo(self.view).offset(0);
//    }];
//    self.baView = bView;
//
//    ChooseAddressCusView *infoV = [ChooseAddressCusView createLoginView];
//    [self.view addSubview:infoV];
//    infoV.storeBack = ^(NSDictionary *store,BOOL isYes){
//        if (isYes) {
//            [self submitAddressInfo:store];
//        }
//        [self changeAddView:YES];
//    };
//    [infoV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(0);
//        make.bottom.equalTo(self.view).offset(self.addHeight);
//        make.right.equalTo(self.view).offset(0);
//        make.height.mas_equalTo(270);
//    }];
//    self.infoView = infoV;
//}

//- (void)submitAddressInfo:(NSDictionary *)dic{
//    NSString *url = [NSString stringWithFormat:@"%@userModifyuserAreaDo",baseUrl];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"tokenKey"] = [AccountTool account].tokenKey;
//    params[@"memberAreaId"] = dic[@"id"];
//    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
//        if ([response.error intValue]==0) {
//            self.mutDic[@"修改区域"] = dic[@"title"];
//            [self.tableView reloadData];
//        }
//        [MBProgressHUD showError:response.message];
//    } requestURL:url params:params];
//}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self changeAddView:YES];
//}

//- (void)changeAddView:(BOOL)isClose{
//    BOOL isHi = YES;
//    if (self.addHeight==270) {
//        if (isClose) {
//            return;
//        }
//        self.addHeight = 0;
//        isHi = NO;
//    }else{
//        self.addHeight = 270;
//        isHi = YES;
//    }
//    [UIView animateWithDuration:0.5 animations:^{
//        [self.infoView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.view).offset(self.addHeight);
//        }];
//        [self.infoView layoutIfNeeded];//强制绘制
//        self.baView.hidden = isHi;
//    }];
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    switch (indexPath.section) {
//        case 0:{
//            if (indexPath.row==1) {
//                UITableViewCell *cell = [self tableView:tableView
//                                  cellForRowAtIndexPath:indexPath];
//                [self creatUIAlertView:cell];
//            }
//        }
//            break;
//        case 1:
//            if (indexPath.row==0){
//                self.putView.hidden = NO;
//            }else if (indexPath.row==1) {
//                AppDownViewC *appVc = [[AppDownViewC alloc]init];
//                [self.navigationController pushViewController:appVc animated:YES];
//            }else if (indexPath.row==2) {
//                PassWordViewController *passVc = [[PassWordViewController alloc]init];
//                passVc.title = @"修改密码";
//                passVc.isForgot = NO;
//                [self.navigationController pushViewController:passVc animated:YES];
//            }else if(indexPath.row==3){
//                EditPhoneNumVc *editNum = [EditPhoneNumVc new];
//                [self.navigationController pushViewController:editNum animated:YES];
//            }else if(indexPath.row==4){
//                EditAddressVC *addVc = [EditAddressVC new];
//                [self.navigationController pushViewController:addVc animated:YES];
//            }else if(indexPath.row==5){
//                [self clearTmpPics];
//            }else{
////                [MBProgressHUD showSuccess:@"功能暂未开放"];
//                UITableViewCell *cell = [self tableView:tableView
//                                  cellForRowAtIndexPath:indexPath];
//                [self setShare:cell];
//            }
//            break;
//        default:
//            break;
//    }
//}
//- (void)setShareDicData{
//    NSString *url = @"https://itunes.apple.com/cn/app/千禧之星珠宝/id1227342902?mt=8";
//    NSString *str = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    self.shareDic = @{@"image":@"http://appapi1.fanerweb.com/images/other/AppleApp.png",
//                      @"url":str,
//                      @"title":@"千禧之星珠宝",@"des":@"下载地址"};
//}
//- (void)setShare:(UITableViewCell *)cell{
//    //创建分享参数（必要）
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    NSArray *arr = @[@(SSDKPlatformTypeSinaWeibo),
//                     @(SSDKPlatformTypeWechat),
//                     @(SSDKPlatformTypeQQ)];
//    [shareParams SSDKSetupShareParamsByText:self.shareDic[@"des"]
//                                     images:[NSURL URLWithString:self.shareDic[@"image"]]
//                                        url:[NSURL URLWithString:self.shareDic[@"url"]]
//                                      title:self.shareDic[@"title"]
//                                       type:SSDKContentTypeAuto];
//    [ShareSDK showShareActionSheet:cell items:arr shareParams:shareParams onShareStateChanged:nil];
//}

- (void)clearTmpPics{
    float tmpSize = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize] :
                    [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
    [[SDImageCache sharedImageCache] clearDisk];
    [MBProgressHUD showSuccess:clearCacheName];
}

- (void)creatUIAlertView:(UITableViewCell *)cell{
    [NewUIAlertTool creatActionSheetPhoto:^{
        [self openAlbum];
    } andCamera:^{
        [self openCamera];
    } andCon:self andView:cell];
}
//打开相机 TypePhotoLibrary > TypeSavedPhotosAlbum
- (void)openCamera{
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}
//打开相册
- (void)openAlbum{
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}
//通过imagePickerController获取图片
- (void)openImagePickerController:(UIImagePickerControllerSourceType)type{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = type;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self presentViewController:ipc animated:YES completion:nil];
    }];
}
#pragma mark -- UIImagePickerControllerDelagate
- (void)imagePickerController:(UIImagePickerController *)picker
                             didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //info中包含选择的图片 UIImagePickerControllerOriginalImage
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.image = image;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadData];
        [self loadUpDateImage:image];
    }];
}
//上传图片
- (void)loadUpDateImage:(UIImage *)image{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *key = [AccountTool account].tokenKey;
    NSString *url = [NSString stringWithFormat:@"%@userModifyHeadPicDo?tokenKey=%@",baseUrl,key];
    [CommonUsedTool loadUpDate:^(NSDictionary *response, NSError *error) {
        NSString *imageStr;
        if ([response[@"error"]intValue]==0) {
            if ([YQObjectBool boolForObject:response[@"data"][@"headPic"]]) {
                imageStr = response[@"data"][@"headPic"];
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (self.editBack) {
                    self.editBack(imageStr);
                }
            }];
        }
    } image:image Dic:params Url:url];
}

@end
