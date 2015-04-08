//
//  AnswerDataManager.h
//  Wenjin
//
//  Created by 秦昱博 on 15/4/1.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerDataManager : NSObject

+ (void)getAnswerDataWithAnswerID:(NSString *)answerId success:(void(^)(NSDictionary *answerData))success failure:(void(^)(NSString *errorStr))failure;
+ (void)getAnswerCommentWithAnswerID:(NSString *)answerId success:(void(^)(NSArray *commentData))success failure:(void(^)(NSString *errorStr))failure;

@end