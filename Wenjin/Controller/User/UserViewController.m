//
//  UserViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "UserViewController.h"
#import "UserDataManager.h"
#import "MsgDisplay.h"
#import "UserHeaderView.h"
#import "data.h"
#import "wjCacheManager.h"
#import "SVPullToRefresh.h"
#import "wjOperationManager.h"
#import "UserListTableViewController.h"
#import "UserFeedTableViewController.h"

@interface UserViewController ()

@end

@implementation UserViewController {
    NSArray *cellArray;
    NSString *userName;
    NSString *userAvatar;
}

@synthesize userId;
@synthesize userTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    if (userId == nil) {
        self.title = @"我";
        if ([data shareInstance].myUID != nil) {
            userId = [data shareInstance].myUID;
        }
    }
    
    self.userTableView.dataSource = self;
    self.userTableView.delegate = self;
    
    cellArray = @[];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.userTableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        self.userTableView.contentInset = insets;
        self.userTableView.scrollIndicatorInsets = insets;
    }
    
    __weak UserViewController *weakSelf = self;
    [self.userTableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshData];
    }];
    
    [self.userTableView triggerPullToRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    if (userId != nil) {
        [UserDataManager getUserDataWithID:userId success:^(NSDictionary *userData) {
            
            UserHeaderView *headerView = [[UserHeaderView alloc]init];
            headerView.delegate = self;
            headerView.usernameLabel.text = userData[@"user_name"];
            headerView.userSigLabel.text = userData[@"signature"];
            headerView.agreeCountLabel.text = userData[@"agree_count"];
            headerView.thanksCountLabel.text = userData[@"thanks_count"];
            [headerView loadAvatarImageWithApartURLString:userData[@"avatar_file"]];
            
            userName = userData[@"user_name"];
            userAvatar = userData[@"avatar_file"];
            
            if ([userData[@"has_focus"] isEqual:@1]) {
                [headerView.followButton setTitle:@"取消关注" forState:UIControlStateNormal];
            } else {
                [headerView.followButton setTitle:@"关注" forState:UIControlStateNormal];
            }
            userTableView.tableHeaderView = headerView;
            
            if ([userId integerValue] == [[data shareInstance].myUID integerValue]) {
                headerView.followButton.hidden = YES;
                cellArray = @[@[@"我的提问", @"我的回答", @"我关注的问题"], @[@"我关注的", @"关注我的"]];
                self.title = @"我";
            } else {
                cellArray = @[@[@"Ta 的提问", @"Ta 的回答", @"Ta 关注的问题"], @[@"Ta 关注的", @"关注 Ta 的"]];
                self.title = userData[@"user_name"];
            }
            
            [userTableView reloadData];
            [userTableView.pullToRefreshView stopAnimating];
        } failure:^(NSString *errorString) {
            [MsgDisplay showErrorMsg:errorString];
            [userTableView.pullToRefreshView stopAnimating];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [cellArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cellArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    cell.textLabel.text = (cellArray[section])[row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"动态";
    } else if (section == 1) {
        return @"用户";
    } else {
        return @"";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    if (section == 0) {
        UserFeedTableViewController *userFeed = [[UserFeedTableViewController alloc]initWithStyle:UITableViewStylePlain];
        userFeed.feedType = row;
        userFeed.userId = userId;
        userFeed.userName = userName;
        userFeed.userAvatar = userAvatar;
        userFeed.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userFeed animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (section == 1) {
        UserListTableViewController *userList = [[UserListTableViewController alloc]initWithStyle:UITableViewStylePlain];
        userList.userType = row;
        userList.userId = userId;
        userList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userList animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

// UserHeaderViewDelegate

- (void)followUser {
    [wjOperationManager followPeopleWithUserID:userId success:^(NSString *operationType) {
        
        UserHeaderView *headerView = (UserHeaderView *)self.userTableView.tableHeaderView;
        
        if ([operationType isEqualToString:@"add"]) {
            [headerView.followButton setTitle:@"取消关注" forState:UIControlStateNormal];
        } else if ([operationType isEqualToString:@"remove"]) {
            [headerView.followButton setTitle:@"关注" forState:UIControlStateNormal];
        }
        
    } failure:^(NSString *errStr) {
        [MsgDisplay showErrorMsg:errStr];
    }];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushSettings"]) {
        self.navigationController.view.backgroundColor = [UIColor whiteColor];
        UIViewController *des = segue.destinationViewController;
        des.hidesBottomBarWhenPushed = YES;
    }
}


@end