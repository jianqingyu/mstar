//
//  PayReturnPageVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/30.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "PayReturnPageVC.h"

@interface PayReturnPageVC ()
@property (weak, nonatomic) IBOutlet UIImageView *payLog;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;
@end

@implementation PayReturnPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付成功页面";
    self.orderBtn.layer.cornerRadius = 5;
    self.centerBtn.layer.cornerRadius = 5;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_return"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
}

- (void)back{
    BaseViewController *baseVc = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:baseVc animated:YES];
}

- (IBAction)continueClick:(id)sender {
    BaseViewController *baseVc = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:baseVc animated:YES];
}

- (IBAction)centerClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
