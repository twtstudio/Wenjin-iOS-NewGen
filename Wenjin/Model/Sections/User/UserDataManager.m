//
//  UserDataManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/2.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "UserDataManager.h"
#import "AFNetworking.h"
#import "wjAPIs.h"
#import "data.h"
#import "wjCacheManager.h"
#import "MJExtension.h"
#import "AnswerInfo.h"
#import "FeedQuestion.h"
#import "TopicInfo.h"

@implementation UserDataManager

+ (void)getUserDataWithID:(NSString *)uid success:(void (^)(UserInfo *))success failure:(void (^)(NSString *))failure {
    if ([data shareInstance].myUID != nil) {
//        if ([uid integerValue] == [[data shareInstance].myUID integerValue]) {
//            [wjCacheManager loadCacheDataWithKey:@"myProfile" andBlock:^(id myProfileCache, NSDate *saveDate) {
//                success(myProfileCache);
//            }];
//        }
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"uid": uid,
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs viewUser] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *userDic = (NSDictionary *)responseObject;
        if ([userDic[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success([UserInfo objectWithKeyValues:userDic[@"rsm"]]);
            });
//            if ([uid integerValue] == [[data shareInstance].myUID integerValue]) {
//                [wjCacheManager saveCacheData:[UserInfo objectWithKeyValues:userDic[@"rsm"]] withKey:@"myProfile"];
//            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(userDic[@"err"]);
            });
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

+ (void)getFollowUserListWithOperation:(NSInteger)operation userID:(NSString *)uid andPage:(NSInteger)page success:(void (^)(NSUInteger, NSArray *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"uid": uid,
                                 @"page": [NSNumber numberWithInteger:page],
                                 @"platform": @"ios"};
    NSString *queueURL = (operation == 0) ? [wjAPIs myFollowUser] : [wjAPIs myFansUser];
    [manager GET:queueURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dicData = (NSDictionary *)responseObject;
        if ([dicData[@"errno"] isEqual:@1]) {
            NSInteger totalRows = [(dicData[@"rsm"])[@"total_rows"] integerValue];
            if (totalRows != 0) {
                NSArray *rowsData = [UserInfo objectArrayWithKeyValuesArray:(dicData[@"rsm"])[@"rows"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(totalRows, rowsData);
                });
            } else {
                NSArray *rowsData = @[];
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(totalRows, rowsData);
                });
            }
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(dicData[@"err"]);
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

+ (void)getUserFeedWithType:(UserFeedType)feedType userID:(NSString *)uid page:(NSInteger)page success:(void (^)(NSUInteger, NSArray *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"uid": uid,
                                 @"page": [NSNumber numberWithInteger:page],
                                 @"platform": @"ios"};
    NSArray *queueURLArray = @[[wjAPIs myQuestions], [wjAPIs myAnswers], [wjAPIs myFollowQuestions]];
    [manager GET:queueURLArray[feedType] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dicData = (NSDictionary *)responseObject;
        if ([dicData[@"errno"] isEqual:@1]) {
            NSInteger totalRows = [(dicData[@"rsm"])[@"total_rows"] integerValue];
            if (totalRows != 0) {
                NSArray *rawData = (dicData[@"rsm"])[@"rows"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (feedType == UserFeedTypeAnswer) {
                        success(totalRows, [AnswerInfo objectArrayWithKeyValuesArray:rawData]);
                    } else {
                        success(totalRows, [FeedQuestion objectArrayWithKeyValuesArray:rawData]);
                    }
                });
            } else {
                NSArray *rowsData = @[];
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(totalRows, rowsData);
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(dicData[@"err"]);
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

+ (void)getFollowTopicListWithUserID:(NSString *)uid page:(NSInteger)page success:(void (^)(NSUInteger, NSArray *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"uid": uid,
                                 @"page": [NSNumber numberWithInteger:page],
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs myFollowTopics] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dicData = (NSDictionary *)responseObject;
        if ([dicData[@"errno"] isEqual:@1]) {
            NSInteger totalRows = [(dicData[@"rsm"])[@"total_rows"] integerValue];
            if (totalRows != 0) {
                NSArray *rowsData = [TopicInfo objectArrayWithKeyValuesArray:(dicData[@"rsm"])[@"rows"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(totalRows, rowsData);
                });
            } else {
                NSArray *rowsData = @[];
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(totalRows, rowsData);
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(dicData[@"err"]);
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

@end
