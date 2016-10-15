//
//  AnswerViewController.h
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DetailType) {
    DetailTypeAnswer = 0,
    DetailTypeArticle = 1,
};

@interface DetailViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) NSString *answerId;
@property (nonatomic) DetailType detailType;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userSigLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIWebView *answerContentView;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *agreeImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *commentItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *questionItem;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIWebView *contentView;
- (IBAction)pushCommentViewController;
- (IBAction)pushQuestionViewController;

@end
