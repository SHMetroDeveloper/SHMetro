//
//  OauthHttpClient.m
//  hello
//
//  Created by 杨帆 on 15/3/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "OauthHttpClient.h"

#import "FMUtils.h"


NSString * const HEADER_CONTENT_TYPE = @"Content-Type";
NSString * const SET_COOKIE_KEY = @"Set-Cookie";
NSString * const COOKIE_KEY = @"Cookie";
NSString * const SESSION_COOKIE = @"JSESSIONID";

NSString * session = @"";

static NSInteger OAUTH_TIMEOUT_INTERVAL = 10.0f;

@interface OauthHttpClient ()

@property (readwrite, nonatomic, strong) NSObject<UrlRewriter> * mUrlRewriter;
@property (readwrite, nonatomic, weak) id<OAuthListener> mListener;

@end

@implementation OauthHttpClient

- (instancetype) init {
    self = [super init];
    if(!self) {
        return nil;
    }
    self.mUrlRewriter = nil;
    return self;
}


- (instancetype) initWithUrlReWriter: (NSObject<UrlRewriter> *) urlReWriter {
    self = [super init];
    if(!self) {
        return nil;
    }
    self.mUrlRewriter = urlReWriter;
    return self;
}

- (NSString*) loginWithUrl: (NSString*) strUrl
                      body: (NSDictionary*) content
                   headers: (NSDictionary*) mHeaders
                  listener: (id<OAuthListener>)listener{
    NSString * res = nil;
    self.mListener = listener;
    session = @"";
    
    if(self.mUrlRewriter != nil) {
        strUrl = [self.mUrlRewriter rewriteUrl:strUrl];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    
    for(NSString * key in mHeaders.allKeys) {
        [manager.requestSerializer setValue:mHeaders[key] forHTTPHeaderField:key];
    }
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = OAUTH_TIMEOUT_INTERVAL;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:HEADER_CONTENT_TYPE];
    
//    NSDictionary * test = @{@"username":@"luoxiaohu", @"password":@"111111"};
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:strUrl parameters:content success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* headers = [operation.response allHeaderFields];
        [self checkSessionCookie:headers];
        NSLog(@"%@", responseObject);
        if(self.mListener) {
            [listener onOAuthSuccess:OAUTH_REQUEST_TYPE_LOGIN :responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [listener onOAuthError:OAUTH_REQUEST_TYPE_LOGIN :error];
    }];
    return res;
}

- (NSString*) getCodeWithUrl: (NSString*) strUrl
                     headers: (NSDictionary*) headers
                    listener: (NSObject<OAuthListener> *)listener {
    headers = [self addSessionCookie:headers];
    if(self.mUrlRewriter != nil) {
        strUrl = [self.mUrlRewriter rewriteUrl:strUrl];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    for(NSString * key in headers.allKeys) {
        [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
    }
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:HEADER_CONTENT_TYPE];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = OAUTH_TIMEOUT_INTERVAL;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSURL* url = [operation.response URL];
        NSString* strQuery = [url query];
        NSString * code = nil;
        NSArray* paramsArray = [strQuery componentsSeparatedByString:NSLocalizedString(@"&", nil)];
        for(int i = 0;i<[paramsArray count];i++) {
            NSString* params = paramsArray[i];
            if([params hasPrefix:@"code"]) {
                code = [params stringByReplacingOccurrencesOfString:@"code=" withString:@""];
                break;
            }
        }
        if(self.mListener) {
            [listener onOAuthSuccess:OAUTH_REQUEST_TYPE_GET_CODE :code];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(self.mListener) {
            [listener onOAuthError:OAUTH_REQUEST_TYPE_GET_CODE :error];
        }
        NSLog(@"Error: %@", error);
    }];
    return @"";
}

- (NSString*) getAccessTokenWithUrl: (NSString*) strUrl
                            headers: (NSDictionary*) headers
                           listener: (NSObject<OAuthListener> *)listener {
    headers = [self addSessionCookie:headers];
    if(self.mUrlRewriter != nil) {
        strUrl = [self.mUrlRewriter rewriteUrl:strUrl];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    for(NSString * key in headers.allKeys) {
        [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
    }
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:HEADER_CONTENT_TYPE];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = OAUTH_TIMEOUT_INTERVAL;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* headers = [operation.response allHeaderFields];
        [self checkSessionCookie:headers];
        NSLog(@"%@", responseObject);
        if(self.mListener) {
            [listener onOAuthSuccess:OAUTH_REQUEST_TYPE_GET_ACCESS_TOKEN :responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [listener onOAuthError:OAUTH_REQUEST_TYPE_GET_ACCESS_TOKEN :error];
    }];

    return @"";

}

- (NSString*) refreshAccessTokenWithUrl: (NSString*) strUrl
                                headers: (NSDictionary*) headers
                               listener: (NSObject<OAuthListener> *)listener{
    headers = [self addSessionCookie:headers];
    if(self.mUrlRewriter != nil) {
        strUrl = [self.mUrlRewriter rewriteUrl:strUrl];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    for(NSString * key in headers.allKeys) {
        [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
    }
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:HEADER_CONTENT_TYPE];
    manager.requestSerializer.timeoutInterval = OAUTH_TIMEOUT_INTERVAL;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    
    [manager POST:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(self.mListener) {
            [listener onOAuthSuccess:OAUTH_REQUEST_TYPE_REFRESH_ACCESS_TOKEN :responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [listener onOAuthError:OAUTH_REQUEST_TYPE_REFRESH_ACCESS_TOKEN :error];
    }];

    return @"";

}

- (void) checkSessionCookie: (NSDictionary*) headers {
    if([headers objectForKey:SET_COOKIE_KEY] ) {
        NSString * cookie = (NSString*)[headers objectForKey:SET_COOKIE_KEY];
        if(![FMUtils isStringEmpty:cookie] && [cookie hasPrefix:SESSION_COOKIE] == 1) {
            NSArray * splitCookie = [cookie componentsSeparatedByString:@";"];
            NSArray * splitSessionId = [splitCookie[0] componentsSeparatedByString:@"="];
            cookie = splitSessionId[1];
            session = cookie;
        }
        
    }
}

- (NSDictionary*) addSessionCookie: (NSDictionary*) headers {
    if(![FMUtils isStringEmpty:session]) {
        NSString * newCookie = nil;
        if([headers objectForKey:COOKIE_KEY]) {
            newCookie = [[NSString alloc] initWithFormat:@"%@=%@;%@", SESSION_COOKIE, session, (NSString *)[headers objectForKey:COOKIE_KEY]];
        } else {
            newCookie = [[NSString alloc] initWithFormat:@"%@=%@", SESSION_COOKIE, session];
        }
        [headers setValue:newCookie forKey:COOKIE_KEY];
    }
    
    return headers;
}


@end
