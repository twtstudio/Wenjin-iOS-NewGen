//
//  TopicDataManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/10.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "TopicDataManager.h"
#import "AFNetworking.h"
#import "wjAPIs.h"
#import "MJExtension.h"
#import "TopicBestAnswerCell.h"

@implementation TopicDataManager

+ (void)getTopicListWithType:(NSString *)topicType andPage:(NSInteger)page success:(void (^)(NSUInteger, NSArray *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"id": topicType,
                                 @"page": [NSNumber numberWithInteger:page],
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs topicList] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

+ (void)getTopicInfoWithTopicID:(NSString *)topicID userID:(NSString *)uid success:(void (^)(TopicInfo *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"uid": uid,
                                 @"topic_id": topicID,
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs topicInfo] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dicData = (NSDictionary *)responseObject;
        if ([dicData[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success([TopicInfo objectWithKeyValues:dicData[@"rsm"]]);
            });
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

+ (void)getTopicBestAnswerWithTopicID:(NSString *)topicId success:(void (^)(NSUInteger, NSArray *))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"id": topicId,
                                 @"platform": @"ios"};
    [manager GET:[wjAPIs topicBestAnswer] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dicData = (NSDictionary *)responseObject;
        if ([dicData[@"errno"] isEqual:@1]) {
            NSDictionary *dic = dicData[@"rsm"];
            if ([dic count] != 0) {
                NSInteger totalRows = [(dicData[@"rsm"])[@"total_rows"] integerValue];
                NSArray *rowsData = [TopicBestAnswerCell objectArrayWithKeyValuesArray:(dicData[@"rsm"])[@"rows"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(totalRows, rowsData);
                });
            } else {
                NSArray *rowsData = @[];
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(0, rowsData);
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
