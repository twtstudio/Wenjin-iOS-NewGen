//
//  AnswerCommentTableViewController.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/8.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "CommentViewController.h"
#import "DetailDataManager.h"
#import "SVPullToRefresh.h"
#import "MsgDisplay.h"
#import "AnswerCommentTableViewCell.h"
#import "PostDataManager.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "CommentInfo.h"
#import "UIScrollView+EmptyDataSet.h"
#import "CommentTextView.h"
#import "Wenjin-Swift.h"
#import "wjAppearanceManager.h"

@interface CommentViewController () <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@property ThemeChangeManager *manager;
@end

@implementation CommentViewController {
    NSMutableArray *rowsData;
    NSUInteger currentPage;
}

@synthesize answerId;
@synthesize detailType;

#pragma mark - Life Cycle

- (id)init {
    self = [super initWithTableViewStyle:UITableViewStylePlain];
    if (self) {
        [self registerClassForTextView:[CommentTextView class]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //slk bug fix
    [self registerPrefixesForAutoCompletion:@[@"#"]];
    
    rowsData = [[NSMutableArray alloc] init];
    
//    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.title = @"评论";
    
    self.bounces = YES;
    self.shakeToClearEnabled = YES;
    self.keyboardPanningEnabled = YES;
    self.shouldScrollToBottomAfterKeyboardShows = NO;
    self.inverted = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    currentPage = 1;
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)] && self.navigationController.navigationBar.translucent == YES) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    
    __weak CommentViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf getRowsData];
    }];
//    if (detailType == DetailTypeArticle) {
//        [self.tableView addInfiniteScrollingWithActionHandler:^{
//            [weakSelf nextPage];
//        }];
//    }
    
    self.tableView.estimatedRowHeight = 68;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _manager = [[ThemeChangeManager alloc] init];
    [_manager handleCommentViewController:self];
    [self.tableView triggerPullToRefresh];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self clearCachedText];
}

#pragma mark - Private Methods

- (void)getRowsData {
    
    if (detailType == DetailTypeAnswer) {
        [DetailDataManager getAnswerCommentWithAnswerID:answerId success:^(NSArray *commentData) {
            rowsData = [[NSMutableArray alloc]initWithArray:commentData];
            [self.tableView.pullToRefreshView stopAnimating];
            [self.tableView reloadData];
        } failure:^(NSString *errStr) {
            [MsgDisplay showErrorMsg:errStr];
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    } else {
        [DetailDataManager getArticleCommentWithID:answerId page:currentPage success:^(NSArray *commentData) {
            if (currentPage == 1) {
                rowsData = [[NSMutableArray alloc] initWithArray:commentData];
            } else {
                if (commentData.count > 0) {
                    [rowsData addObjectsFromArray:commentData];
                } else {
                    [MsgDisplay showErrorMsg:@"已到达最后一页~"];
                    currentPage --;
                }
            }
            [self.tableView.pullToRefreshView stopAnimating];
            [self.tableView.infiniteScrollingView stopAnimating];
            [self.tableView reloadData];
        } failure:^(NSString *errStr) {
            [MsgDisplay showErrorMsg:errStr];
            [self.tableView.pullToRefreshView stopAnimating];
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    }
}

- (void)nextPage {
    currentPage ++;
    [self getRowsData];
}

- (void)postComment:(NSString *)comment {
    if (detailType == DetailTypeAnswer) {
        [PostDataManager postAnswerCommentWithAnswerID:answerId andMessage:comment success:^{
            [MsgDisplay dismiss];
            [MsgDisplay showSuccessMsg:@"评论添加成功！"];
            [self getRowsData];
        } failure:^(NSString *errStr) {
            [MsgDisplay dismiss];
            [MsgDisplay showErrorMsg:errStr];
        }];
    } else {
        [PostDataManager postArticleCommentWithArticleID:answerId andMessage:comment success:^{
            [MsgDisplay dismiss];
            [MsgDisplay showSuccessMsg:@"评论添加成功！"];
            [self getRowsData];
            
        } failure:^(NSString *errStr) {
            [MsgDisplay dismiss];
            [MsgDisplay showErrorMsg:errStr];
        }];
    }
}

#pragma mark - Text Action Methods

- (void)didPressRightButton:(id)sender {
    [self.textView refreshFirstResponder];
    [MsgDisplay showLoading];
    [self postComment:self.textView.text];
    
    [super didPressRightButton:sender];
}

#pragma mark - UITableViewDelegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [rowsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleCellIdentifier = @"simpleTableCellIdentifier";
    AnswerCommentTableViewCell *cell = (AnswerCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AnswerCommentTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSUInteger row = [indexPath row];
    CommentInfo *tmp = rowsData[row];
    if (detailType == DetailTypeAnswer) {
        cell.usernameLabel.text = tmp.nickName;
        NSString *replyUserText = (tmp.atUid != 0) ? [NSString stringWithFormat:@"回复 %@：", tmp.atNickName] : @"";
        cell.commentLabel.text = [NSString stringWithFormat:@"%@%@", replyUserText, tmp.content];
    } else {
        cell.usernameLabel.text = tmp.artComNickName;
        NSString *replyUserText = (tmp.atUid != 0) ? [NSString stringWithFormat:@"回复 %@：", tmp.atNickName] : @"";
        cell.commentLabel.text = [NSString stringWithFormat:@"%@%@", replyUserText, tmp.artComContent];
    }
    cell.usernameLabel.textColor = [wjAppearanceManager mainTintColor];
    cell.transform = self.tableView.transform;
    [_manager handleAnswerCommentTableViewCell:cell];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    CommentInfo *tmp = rowsData[row];
    NSString *replyName = (detailType == DetailTypeAnswer) ? tmp.nickName : tmp.artComNickName;
    replyName = [replyName stringByReplacingOccurrencesOfString:@"(作者)" withString:@""];
    self.textView.text = [NSString stringWithFormat:@"@%@:", replyName];
    [self.textView becomeFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - EmptyDataSet

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无评论";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"desperateSmile"];
}

@end
