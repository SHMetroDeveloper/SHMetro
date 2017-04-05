//
//  JsonRequest.m
//  hello
//
//  Created by 杨帆 on 15/3/25.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "JsonRequest.h"
#import "FMUtils.h"

typedef void (^operationSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^operationFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface JsonRequest()

@property (readwrite, nonatomic, strong) NSNumber * projectId;
@property (readwrite, nonatomic, strong) NSString * language;
@property (readwrite, nonatomic, strong) NSString * method;
@property (readwrite, nonatomic, strong) NSDictionary * parameter;

@property (readwrite, nonatomic) operationSuccessBlock success;
@property (readwrite, nonatomic) operationFailureBlock failure;
@end

@implementation JsonRequest

- (instancetype) initWithMethod: (NSString *) method
                            URL: (NSString *) strurl
               requestParameter: (NSDictionary *) parameter
                        success: (operationSuccessBlock) success
                        failure: (operationFailureBlock) failure
                    accessToken: (NSString *)token
                       deviceId: (NSString *)deviceId
                      projectId:(NSNumber *) projectId{
    self = [super init];
    if(!self) {
        return nil;
    }
    
    _accessToken = token;
    _deviceId = deviceId;
    _success = success;
    _failure = failure;
    _method = method;
    _parameter = parameter;
    _projectId = projectId;
    _mainUrl = strurl;
    
    NSMutableURLRequest * request = [self getRequest];
    
    _op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    _op.responseSerializer = [AFJSONResponseSerializer serializer];
    [_op setCompletionBlockWithSuccess:success failure:failure];
    
    return self;
}

- (NSURL *) getUrl {
    NSURL * url;
    NSString * tmpUrl;
    NSString * language = [FMUtils getPreferredLanguage];
    if(_projectId) {
        tmpUrl = [[NSString alloc] initWithFormat:@"%@?current_project=%lld&i18n=%@&access_token=%@", _mainUrl, _projectId.longLongValue, language, _accessToken];
    } else {
        tmpUrl = [[NSString alloc] initWithFormat:@"%@?access_token=%@", _mainUrl, _accessToken];
    }
    url = [[NSURL alloc] initWithString:tmpUrl];
    return url;
}

- (NSMutableURLRequest *) getRequest {
    NSURL * url = [self getUrl];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    
    [request setValue:_deviceId forHTTPHeaderField:@"Device-Id"];
    [request setValue:@"android" forHTTPHeaderField:@"Device-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString * auth = [[NSString alloc] initWithFormat:@"Bearer %@", _accessToken];
    [request setValue:auth forHTTPHeaderField:@"Authorization"];
    
    BOOL isGet = [_method compare:@"get" options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame;
    if(isGet) {
        
    }
    [request setHTTPMethod:@"POST"];
    
    NSData * content = [FMUtils dictionaryToData:_parameter];
    [request setHTTPBody:content];
    
    return request;
}

- (AFHTTPRequestOperation *) getRetryOperation {
    NSMutableURLRequest * request = [self getRequest];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:_success failure:_failure];
    
    return operation;
}

@end