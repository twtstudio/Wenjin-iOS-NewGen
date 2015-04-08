//
//  AnswerViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "AnswerViewController.h"
#import "AnswerDataManager.h"
#import "wjStringProcessor.h"
#import "MsgDisplay.h"
#import "wjAPIs.h"
#import "ALActionBlocks.h"
#import "UserViewController.h"
#import "UIImageView+AFNetworking.h"
#import "wjOperationManager.h"
#import <KVOController/FBKVOController.h>
#import "AnswerCommentTableViewController.h"

@interface AnswerViewController ()

@end

@implementation AnswerViewController {
    NSInteger voteValue;
}

@synthesize answerId;

@synthesize userAvatarView;
@synthesize userNameLabel;
@synthesize userSigLabel;
@synthesize agreeBtn;
@synthesize answerContentView;
@synthesize userInfoView;
@synthesize agreeCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"回答";
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    FBKVOController *kvoController = [FBKVOController controllerWithObserver:self];
    self.KVOController = kvoController;
    [self.KVOController observe:self keyPath:@"agreeCount" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [agreeBtn setTitle:[NSString stringWithFormat:@"%ld", (long)agreeCount] forState:UIControlStateNormal];
    }];
    
    [AnswerDataManager getAnswerDataWithAnswerID:answerId success:^(NSDictionary *ansData) {
        NSString *processedHTML = [wjStringProcessor convertToBootstrapHTMLWithContent:ansData[@"answer_content"]];
        [answerContentView loadHTMLString:processedHTML baseURL:[NSURL URLWithString:[wjAPIs baseURL]]];
        userNameLabel.text = ansData[@"user_name"];
        self.title = [NSString stringWithFormat:@"%@ 的回答", ansData[@"user_name"]];
        userSigLabel.text = ansData[@"signature"];
        [userAvatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [wjAPIs avatarPath], ansData[@"avatar_file"]]]];
        userAvatarView.layer.cornerRadius = userAvatarView.frame.size.width / 2;
        userAvatarView.clipsToBounds = YES;
        
        voteValue = [ansData[@"vote_value"] integerValue];
        [self setValue:ansData[@"agree_count"] forKey:@"agreeCount"];

        [agreeBtn addTarget:self action:@selector(voteOperation) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *userTapRecognizer = [[UITapGestureRecognizer alloc]initWithBlock:^(id weakSender) {
            UserViewController *uVC = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
            uVC.userId = [ansData[@"uid"] stringValue];
            [self.navigationController pushViewController:uVC animated:YES];
        }];
        [userTapRecognizer setNumberOfTapsRequired:1];
        [userInfoView setUserInteractionEnabled:YES];
        [userInfoView addGestureRecognizer:userTapRecognizer];
        
    } failure:^(NSString *errStr) {
        [MsgDisplay showErrorMsg:errStr];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)voteOperation {
    
    NSString *titleString;
    NSString *msgString;
    NSString *agreeActionString;
    NSString *disagreeActionString;
    
    titleString = NSLocalizedString(@"Vote", nil);
    
    if (voteValue == 1) {
        // 已赞同
        msgString = @"已赞同";
        agreeActionString = @"取消赞同";
        disagreeActionString = @"反对";
    } else if (voteValue == -1) {
        // 已反对
        msgString = @"已反对";
        agreeActionString = @"赞同";
        disagreeActionString = @"取消反对";
    } else if (voteValue == 0) {
        // 无操作
        msgString = @"";
        agreeActionString = @"赞同";
        disagreeActionString = @"反对";
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleString message:msgString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:agreeActionString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [wjOperationManager voteAnswerWithAnswerID:answerId operation:1 success:^{
            switch (voteValue) {
                case 1:
                    voteValue = 0;
                    [self setValue:[NSNumber numberWithInteger:agreeCount - 1] forKey:@"agreeCount"];
                    break;
                    
                case 0:
                    voteValue = 1;
                    [self setValue:[NSNumber numberWithInteger:agreeCount + 1] forKey:@"agreeCount"];
                    break;
                    
                case -1:
                    voteValue = 1;
                    [self setValue:[NSNumber numberWithInteger:agreeCount + 1] forKey:@"agreeCount"];
                    break;
                    
                default:
                    break;
            }
        } failure:^(NSString *errStr) {
            [MsgDisplay showErrorMsg:errStr];
        }];
    }];
    UIAlertAction *disagreeAction = [UIAlertAction actionWithTitle:disagreeActionString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [wjOperationManager voteAnswerWithAnswerID:answerId operation:-1 success:^{
            switch (voteValue) {
                case 1:
                    voteValue = -1;
                    [self setValue:[NSNumber numberWithInteger:agreeCount - 1] forKey:@"agreeCount"];
                    break;
                    
                case 0:
                    voteValue = -1;
                    break;
                    
                case -1:
                    voteValue = 0;
                    break;
                    
                default:
                    break;
            }
        } failure:^(NSString *errStr) {
            [MsgDisplay showErrorMsg:errStr];
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:agreeAction];
    [alertController addAction:disagreeAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)pushCommentViewController {
    AnswerCommentTableViewController *commentVC = [[AnswerCommentTableViewController alloc]initWithStyle:UITableViewStylePlain];
    commentVC.answerId = answerId;
    [self.navigationController pushViewController:commentVC animated:YES];
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
