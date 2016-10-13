//
//  MainTabBarController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/28.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "MainTabBarController.h"
#import "wjCookieManager.h"
#import "wjDatabaseManager.h"
#import "data.h"
#import "wjCacheManager.h"
#import "wjAccountManager.h"
#import <KVOController/FBKVOController.h>
#import "NotificationManager.h"
#import "APService.h"
#import <KVOController/NSObject+FBKVOController.h>
#import "AccountViewController.h"
#import "wjAPIs.h"
#import "MsgDisplay.h"
#import "Wenjin-Swift.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

@synthesize showNotLoggedInView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [wjAppearanceManager setTintColor];
    // Do any additional setup after loading the view.
    
    //[[self.tabBar.items objectAtIndex:1] setBadgeValue:@"3"];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"%@", path);
    
    // 防止1.0用户闪退
    [wjCacheManager removeCacheDataForKey:@"homeCache"];
    
    FBKVOController *kvoController = [FBKVOController controllerWithObserver:self];
    self.KVOController = kvoController;
    [self.KVOController observe:self keyPath:@"showNotLoggedInView" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        if (showNotLoggedInView) {
            NotLoggedInView *notLoggedView = [[NotLoggedInView alloc]init];
            notLoggedView.frame = self.view.frame;
            notLoggedView.delegate = self;
            [self.view addSubview:notLoggedView];
        } else {
            for (UIView *view in self.view.subviews) {
                if ([view isKindOfClass:[NotLoggedInView class]]) {
                    
                    [view removeFromSuperview];
                }
            }
            
            [wjCookieManager loadCookieForKey:@"login"];
            [wjCacheManager loadCacheDataWithKey:@"userData" andBlock:^(id userData, NSDate *saveDate) {
                [data shareInstance].myUID = [userData[@"uid"] stringValue];
                [APService setAlias:[data shareInstance].myUID callbackSelector:nil object:nil];
            }];
            
            [self refreshNotification];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotification) name:@"newNotification" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"logged in? %d", [wjAccountManager userIsLoggedIn]);
    if (![wjAccountManager userIsLoggedIn]) {
        [self setValue:@YES forKey:@"showNotLoggedInView"];
    } else {
        [self setValue:@NO forKey:@"showNotLoggedInView"];
    }
    
    ThemeChangeManager *manager = [[ThemeChangeManager alloc] init];
    [manager handleTabBar:self];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Method

- (void)refreshNotification {
    if ([wjAccountManager userIsLoggedIn]) {
        [NotificationManager getUnreadNotificationNumberWithSuccess:^(NSUInteger inboxNum, NSUInteger notificationNum) {
            if (notificationNum > 0) {
                [[self.tabBar.items objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%lu", (unsigned long)notificationNum]];
                [APService setBadge:notificationNum];
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:notificationNum];
            } else if (notificationNum == 0) {
                [[self.tabBar.items objectAtIndex:1] setBadgeValue:nil];
                [APService resetBadge];
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            }
        } failure:^(NSString *errStr) {
            
        }];
    }
}

#pragma mark - NotLoggedInViewDelegate

- (void)presentLoginController {
    /*LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [login setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:login animated:YES completion:nil];*/
    
    AccountViewController *acountVC = [[AccountViewController alloc]initWithAddress: [wjAPIs loginURL]];
    [acountVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:acountVC animated:YES completion:nil];
}

- (void)presentRegisterController {
    
    //[MsgDisplay showErrorMsg:@"暂时没有这个功能"];
    AccountViewController *acountVC = [[AccountViewController alloc]initWithAddress: [wjAPIs registerURL]];
    [acountVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:acountVC animated:YES completion:nil];
    
    /*AcountWebViewController *acountVC = [[AcountWebViewController alloc]initWithAddress: @"http://login.twtstudio.com"];
    [acountVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:acountVC animated:YES completion:nil];*/
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
