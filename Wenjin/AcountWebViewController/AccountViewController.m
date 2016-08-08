//
//  AccountViewController.m
//  Wenjin
//
//  Created by JinHongxu on 16/7/20.
//  Copyright © 2016年 TWT Studio. All rights reserved.
//

#import "AccountViewController.h"
#import "WebViewJavascriptBridge.h"
#import "wjAccountManager.h"
#import "wjCookieManager.h"
#import "wjCacheManager.h"
#import "wjAppearanceManager.h"
#import "wjAPIs.h"
#import "MainTabBarController.h"
#import "data.h"
#import "MsgDisplay.h"
#import "HomeViewController.h"
@interface AccountViewController ()

@property (strong, nonatomic) NSString *URLString;
@property (strong, nonatomic) NSURLRequest *request;
@property (strong, nonatomic) UIWebView *webView;
@property UIStatusBarStyle *customPreferredStatusBarStyle;
@property WebViewJavascriptBridge *bridge;
@end

@implementation AccountViewController

- (instancetype)initWithAddress:(NSString *)URLString {
    self.URLString = URLString;
    return [self initWithURL:[NSURL URLWithString:URLString]];
}

- (instancetype)initWithURL:(NSURL*)pageURL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:pageURL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest*)request {
    self = [super init];
    if (self) {
        self.request = request;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.customPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    //delete previous cookies that could be bad
    NSArray *fooCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    if ([fooCookies count] > 0) {
        for(NSHTTPCookie *cookie in fooCookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            NSLog(@"Kicked some villains out!");
        }
    } else {
        NSLog(@"No villain was found");
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return *(_customPreferredStatusBarStyle);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    self.webView.delegate = self;
    [self.webView loadRequest:self.request];
    self.webView.scrollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.webView];
    
    
    
    UIView *fakeNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    fakeNavigationBar.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
    [self.view addSubview:fakeNavigationBar];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(16, 24, 0, 0)];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button sizeToFit];
    [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [fakeNavigationBar addSubview:button];
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge registerHandler:@"loginSuccessHandler" handler:^(id JSONData, WVJBResponseCallback responseCallback) {
        NSDictionary *loginData = (NSDictionary *)JSONData;
        if ([loginData[@"errno"] isEqual:@1]) {
            NSDictionary *userData = loginData[@"rsm"];
            NSString *uid = [userData[@"uid"] stringValue];
            //NSString *user_name = userData[@"user_name"];
            //NSString *avatar_file = userData[@"avatar_file"];
            
            [wjCookieManager saveCookieForURLString:self.URLString andKey:@"login"];
            [wjCacheManager saveCacheData:userData withKey:@"userData"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userIsLoggedIn"];
            [data shareInstance].myUID = uid;
            
            if ([self.presentingViewController isKindOfClass:[UITabBarController class]]) {
                [self.presentingViewController setValue:@NO forKey:@"showNotLoggedInView"];
                
                UITabBarController *presentingTabBarController = (UITabBarController *)self.presentingViewController;
                for (UIViewController *navViewController in presentingTabBarController.viewControllers) {
                    if ([navViewController isKindOfClass:[UINavigationController class]]) {
                        UINavigationController *navController = (UINavigationController *)navViewController;
                        UIViewController *rVC = navController.viewControllers[0];
                        if ([rVC isKindOfClass:[HomeViewController class]]) {
                            HomeViewController *hVC = (HomeViewController *)rVC;
                            hVC.shouldRefresh = YES;
                        }
                    }
                }
                
            } else {
                [self.presentingViewController.navigationController.tabBarController setValue:@NO forKey:@"showNotLoggedInView"];
            }

            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [MsgDisplay showErrorMsg:@"登录失败，请检查网络设置"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    
    NSLog(@"Cleared!");
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
