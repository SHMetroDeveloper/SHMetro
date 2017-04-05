//
//  NetRequest.m
//  hello
//
//  Created by 杨帆 on 15/3/25.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "NetRequest.h"
#import "JsonRequest.h"
#import "FMUtils.h"
#import "SystemConfig.h"
#import "LoginListener.h"
#import "BaseResponse.h"

static NSInteger NET_REQUEST_TIMEOUT_INTERVAL = 30.0f; //网络请求超时时间
static NSInteger MAX_RETRY_COUNT = 3; //网络请求失败之后重试的次数
static NSString * CustomErrorDomain = @"com.facilityone.shang";

NS_ENUM(NSInteger, CustomErrorType) {
    CUSTOM_ERROR_TYPE_UNKNOW,
    CUSTOM_ERROR_TYPE_RETRY_COUNT,  //网络请求重试次数超过限制
};

NSOperationQueue * mRequestQueue;

NSMutableArray * handlerArray;


@interface NetErrorHandler () <LoginListener>

@property (readwrite, nonatomic, copy) NetRequestSuccessBlock successHandler;   //供网络请求的底层调用,用于拦截 success 回调
@property (readwrite, nonatomic, copy) NetRequestFailBlock failureHandler; //供网络请求的底层调用,用于拦截 failure 回调

@property (readwrite, nonatomic, copy) NetRequestSuccessBlock success;  //存储上层的 success 回调入口
@property (readwrite, nonatomic, copy) NetRequestFailBlock failure;   //存储上层的 failure 回调入口

@property (readwrite, nonatomic, strong) JsonRequest *request;
@property (readwrite, nonatomic, assign) NSInteger errCount;
@end

@implementation NetErrorHandler

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initHandler];
    }
    return self;
}

- (void) initHandler {
    if(!_failureHandler) {
        
        __weak id weakSelf = self;
        _successHandler = ^(AFHTTPRequestOperation *operation, id responseObject) {
            [weakSelf callBackSuccessWith:operation response:responseObject];
        };
        _failureHandler = ^(AFHTTPRequestOperation *operation, NSError *error) {
            NSDictionary * header = operation.response.allHeaderFields;
            NSString * strMsg = [header valueForKeyPath:@"Www-Authenticate"];
            BaseResponse * response = operation.responseObject;
            NSData * serverData = [error userInfo][AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary * userInfo = [FMUtils dataToDictionary:serverData];
            NSLog(@"error: %@", userInfo[@"fmcode"]);
            if(strMsg) {
                if([strMsg containsString:@"expired_token"]) {  //刷新token
                    NSLog(@"expired_token");
                    [[SystemConfig getOauthFM] refreshToken:[[SystemConfig getOauthFM] getToken].mRefreshToken listener:weakSelf];
                    
                } else if([strMsg containsString:@"invalid_token"]) {   //重新登录
                    NSLog(@"invalid_token");
                    [weakSelf muteLogin];
                }
            } else {
                [weakSelf callBackFailureWith:operation error:error];
            }
        };
        _errCount = 0;
    }
}

- (void) callBackSuccessWith:(AFHTTPRequestOperation *) operation response:(id) responseObject {
    if(_success) {
        _success(operation, responseObject);
    }
    [handlerArray removeObject:self];   //请求结束之后需要将资源移除
}

- (void) callBackFailureWith:(AFHTTPRequestOperation *)operation error:(NSError *)error {
    if(_failure) {
        _failure(operation, error);
    }
    [handlerArray removeObject:self];   //请求结束之后需要将资源移除
}

- (void) setSuccessCallbackBlock:(NetRequestSuccessBlock) success {
    _success = success;
}

- (void) setErrorCallbackBlock:(NetRequestFailBlock)failure {
    _failure = failure;
}

//用于刷新token之后重新请求网络数据
- (void) setRequest:(JsonRequest *)request {
    _request = request;
}

- (void) muteLogin {
    NSString * userName = [SystemConfig getLoginName];
    NSString * password = [SystemConfig getCurrentUserPassword];
    [[SystemConfig getOauthFM] startOauthByName:userName password:password listener:self];
}

#pragma mark - token
- (void) onLoginSuccess:(Token *)token {
    NSLog(@"onSuccess --- NetRequest ----");
    if(_request) {          //刷新token
        _request.accessToken = token.mAccessToken;
    }
    _errCount++;
    __weak id weakSelf = self;
    if(_errCount <= MAX_RETRY_COUNT) {
        if(_request) {
            NSLog(@"------- retry -------");
            [mRequestQueue addOperation:[_request getRetryOperation]];
        }
    } else if(weakSelf) {
        [weakSelf callBackFailureWith:nil error:[NSError errorWithDomain:CustomErrorDomain code:CUSTOM_ERROR_TYPE_RETRY_COUNT userInfo:nil]];
    }
}

- (void) onLoginError:(NSError *)error {
    NSLog(@"onError --- NetRequest---");
    __weak id weakSelf = self;
    if(weakSelf) {
        if(_request) {
            [weakSelf callBackFailureWith:nil error:error];
        }
        
    }
}

- (void) onLoginCancel {
    NSLog(@"onCancel --- NetRequest");
    __weak id weakSelf = self;
    if(weakSelf) {
        [weakSelf callBackFailureWith:nil error:nil];
    }
}
@end

@interface NetRequest ()

//@property (readwrite, nonatomic, strong) NetErrorHandler * errorHandler;


@end


@implementation NetRequest

- (instancetype) init {
    self = [super init];
    if(self) {
//        if(!_errorHandler) {
//            _errorHandler = [[NetErrorHandler alloc] init];
//        }
        if(!handlerArray) {
            handlerArray = [[NSMutableArray alloc] init];
        }
    }
    return self;
}
- (void) initNetRequest {
    if(mRequestQueue == nil) {
        mRequestQueue = [NSOperationQueue mainQueue];
    }
}

- (void) addRequest:(BaseRequest *) request
            success: (NetRequestSuccessBlock)success
            failure: (NetRequestFailBlock)failure
        accessToken: (NSString *)token
           deviceId: (NSString *)devId
          projectId: (NSNumber *) projectId {
    if(!mRequestQueue) {
        [self initNetRequest];
    }
    NetErrorHandler * errorHandler = [[NetErrorHandler alloc] init];
    [errorHandler setSuccessCallbackBlock:success];
    [errorHandler setErrorCallbackBlock:failure];
    
    JsonRequest * jRequest = [[JsonRequest alloc] initWithMethod:@"POST" URL:[request getUrl] requestParameter:[request toJson] success:errorHandler.successHandler failure:errorHandler.failureHandler accessToken:token deviceId:devId projectId:projectId];
    [errorHandler setRequest:jRequest];
//    [jRequest setTimeoutInterval:NET_REQUEST_TIMEOUT_INTERVAL];
    
    [handlerArray addObject:errorHandler];
    
    //自定义时间超时,之所以采取这种方式，是因为 Apple 做了限制，设置了setHTTPBody 之后 timeout 失效
    [NSTimer scheduledTimerWithTimeInterval:NET_REQUEST_TIMEOUT_INTERVAL target: self selector: @selector(handleTimer:) userInfo:jRequest repeats:NO];
    
    [mRequestQueue addOperation:jRequest.op];
}

//请求超时之后任务取消
- (void) handleTimer:(NSTimer *) timer {
    if(timer.userInfo) {
        JsonRequest * jRequest = timer.userInfo;
        NSOperation * op = jRequest.op;
        if(![op isFinished]) {
            NSLog(@"请求超时，任务取消 --- %@", jRequest.mainUrl);
            [op cancel];
        }
    }
}

- (void) request: (BaseRequest *) request
         success: (NetRequestSuccessBlock)success
         failure: (NetRequestFailBlock)failure
     accessToken: (NSString *)token
        deviceId: (NSString *)devId
       projectId:(NSNumber *) projectId{
    
//    [_errorHandler setErrorCallbackBlock:failure];
    NetErrorHandler * errorHandler = [[NetErrorHandler alloc] init];
    [errorHandler setSuccessCallbackBlock:success];
    [errorHandler setErrorCallbackBlock:failure];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString* strurl = [request getUrl];
    NSString * language = [FMUtils getPreferredLanguage];
    if(projectId) {
        strurl = [[NSString alloc] initWithFormat:@"%@?current_project=%lld&i18n=%@&access_token=%@", strurl, projectId.longLongValue, language, token];
    } else {
        strurl = [[NSString alloc] initWithFormat:@"%@?access_token=%@", strurl, token];
    }
    
    NSString* deviceId = [FMUtils getDeviceIdString];
    NSDictionary* parameter = [request toJson];
    
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    [manager.requestSerializer setValue:deviceId forHTTPHeaderField:@"Device-Id"];
    [manager.requestSerializer setValue:@"android" forHTTPHeaderField:@"Device-Type"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = NET_REQUEST_TIMEOUT_INTERVAL;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString * auth = [[NSString alloc] initWithFormat:@"Bearer %@", token];
    [manager.requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//申明返回的结果是json类型
    
    [manager POST:strurl parameters:parameter success:errorHandler.successHandler failure:errorHandler.failureHandler];
}

- (void) cacelAll {
    if(mRequestQueue) {
        [mRequestQueue cancelAllOperations];
    }
}

@end
