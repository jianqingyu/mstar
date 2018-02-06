//
//  OrderPassVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/10/20.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "OrderPassVC.h"

@interface OrderPassVC ()<UIWebViewDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,  copy) NSString *url;
@end

@implementation OrderPassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.delegate = self;
    if (@available(iOS 11.0, *)) {
        _webView.scrollView.contentInsetAdjustmentBehavior =
        UIScrollViewContentInsetAdjustmentNever;
    }
    self.url = @"http://appapi1.fanerweb.com/htapp/index.html";
    NSString *reUrl = [NSString stringWithFormat:@"%@?tokenKey=%@",self.url,[AccountTool account].tokenKey];
    NSURLRequest *urlRe = [NSURLRequest requestWithURL:[NSURL URLWithString:reUrl]];
    [self.webView loadRequest:urlRe];
    self.navigationController.delegate = self;
    [self creatNaviBtn];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)creatNaviBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(5, 20, 30, 50);
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)backClick{
    if ([_webView canGoBack]) {
        [_webView goBack];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
