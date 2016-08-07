//
//  AccountViewController.h
//  Wenjin
//
//  Created by JinHongxu on 16/7/20.
//  Copyright © 2016年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UIViewController<UIWebViewDelegate>


- (instancetype)initWithAddress:(NSString*)URLString;
- (instancetype)initWithURL:(NSURL *)pageURL;
- (instancetype)initWithURLRequest:(NSURLRequest*)request;

@end
