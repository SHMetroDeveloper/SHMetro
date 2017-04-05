//
//  JsonRequest.h
//  hello
//
//  Created by 杨帆 on 15/3/25.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFnetWorking.h"

@interface JsonRequest : NSMutableURLRequest

@property (readwrite, nonatomic, copy) NSString * accessToken;
@property (readwrite, nonatomic, copy) NSString * deviceId;
@property (readwrite, nonatomic, strong) AFHTTPRequestOperation *op;
@property (readwrite, nonatomic, strong) NSString *mainUrl;

- (instancetype) initWithMethod: (NSString *) method
                            URL: (NSString *) url
               requestParameter: (NSDictionary *) parameter
                        success: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                    accessToken: (NSString *)token
                       deviceId: (NSString *)deviceId
                      projectId: (NSNumber *) projectId;

- (AFHTTPRequestOperation *) getRetryOperation;
@end