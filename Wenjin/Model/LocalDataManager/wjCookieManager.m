//
//  wjCookieManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/29.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "wjCookieManager.h"

@implementation wjCookieManager

+ (void)saveCookieForURLString:(NSString *)urlStr andKey:(NSString *)key {

    NSMutableArray *cookies = [NSMutableArray arrayWithArray:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:urlStr]]];
    //NSLog(@"😀%lu", (unsigned long)cookies.count);
    /*
    if ([cookies count] > 2) {
        for (NSInteger i = 0; i < [cookies count] - 2; ++i) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookies[i]];
            
            [cookies removeObjectAtIndex:i];
        }
    }
    */
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
}

+ (void)loadCookieForKey:(NSString *)key {
    NSData *cookiesData = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if([cookiesData length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesData];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
}

+ (void)removeCookieForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
}

@end
