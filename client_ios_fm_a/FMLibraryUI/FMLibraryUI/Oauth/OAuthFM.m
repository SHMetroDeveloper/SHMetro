//
//  OAuthFM.m
//  hello
//
//  Created by 杨帆 on 15/3/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "OAuthFM.h"
#import "FMConfig.h"
#import "FMToken.h"
#import "AccessTokenKeeper.h"
#import "OauthHttpClient.h"
#import "OAuthUserInfo.h"
#import "OAuthListener.h"
//#import "SBJSON.h"
#import "AFURLRequestSerialization.h"

#import "LoginListener.h"


NSString* errorDomain = @"OauthFM";


@interface OAuthFM () <OAuthListener>

@property (readwrite, nonatomic, strong) FMConfig * mConfig;
@property (readwrite, nonatomic, strong) AccessTokenKeeper * mKeeper;
@property (readwrite, nonatomic, strong) OauthHttpClient * mFMOauthHttpClient;

@property (readwrite, nonatomic, copy) NSString * mServerUrl;
@property (readwrite, nonatomic, copy) NSString * mLoginUrl;
@property (readwrite, nonatomic, strong) NSMutableDictionary * mHeaders;
@property (readwrite, nonatomic, strong) OAuthUserInfo * mUserInfo;

@property (readwrite, nonatomic, weak) id<LoginListener> mLoginListener;



- (void) oauthThreadMethod: (id) param ;
- (void) loginWith: (NSString *) userName
          password: (NSString *) password;

- (void) getCodeThreadMethod;
- (void) getCode;

- (void) getAccessTokenThreadMethod: (NSString*) code;
- (void) getAccessToken: (NSString*) code;

- (void) getRefreshTokenThreadMethod: (NSString*) refreshToken;

@end

@implementation OAuthFM

- (instancetype) initWithAppKey:(NSString *) appkey
                      appScrete: (NSString*) appScrete
                      serverUrl: (NSString*) serverUrl
                       deviceId: (NSString*) deviceId {
    self = [super init];
    if(!self) {
        return nil;
    }
    self.mServerUrl = serverUrl;
    self.mLoginUrl = [[NSString alloc] initWithFormat:@"%@%@", serverUrl, @"/login/session"];
    self.mHeaders = [[NSMutableDictionary alloc] init];
    [self.mHeaders setValue:@"android" forKeyPath: @"Device-Type"];
    [self.mHeaders setValue:deviceId forKeyPath: @"Device-Id"];
    
    NSString * codeUrl = [[NSString alloc] initWithFormat: @"%@%@", serverUrl, @"/oauth2/auth"];
    NSString * accessTokenUrl = [[NSString alloc] initWithFormat: @"%@%@", serverUrl, @"/oauth2/token"];
    NSString * refreshTokenUrl = [[NSString alloc] initWithFormat: @"%@%@", serverUrl, @"/oauth2/token"];
    NSString * codeRedirectUrl = [[NSString alloc] initWithFormat: @"%@%@", serverUrl, @"/main.html"];
    NSString * accessTokenRedirectUrl = [[NSString alloc] initWithFormat: @"%@%@", serverUrl, @"/main/index"];
    NSString * refreshTokenRedirecUrl = [[NSString alloc] initWithFormat: @"%@%@", serverUrl, @"/main/index"];
    
    self.mConfig = [[FMConfig alloc] initWithAppKey:appkey appSecret:appScrete codeUrl:codeUrl accessTokenUrl:accessTokenUrl refreshTokenUrl:refreshTokenUrl codeRedirectUrl:codeRedirectUrl accessTokenRedirectUrl:accessTokenRedirectUrl refreshTokenRedirectUrl:refreshTokenRedirecUrl];
    
    self.mKeeper = [[AccessTokenKeeper alloc] initWithName: @"OAuthConfig"];
    self.mFMOauthHttpClient = [[OauthHttpClient alloc] init];
    
    self.mUserInfo = nil;
    
    return self;
}

- (OAuthConfig *) getConfig {
    return self.mConfig;
}

- (Token *) getToken {
    return [self.mKeeper readAccessToken];
}

- (void) clearToken {
    [self.mKeeper clear];
}

- (void) loginWith: (NSString *) userName
          password: (NSString *) password {
    NSMutableDictionary * user = [[NSMutableDictionary alloc] init];
    [user setValue:userName forKeyPath:@"username"];
    [user setValue:password forKeyPath:@"password"];
    [self.mFMOauthHttpClient loginWithUrl:self.mLoginUrl body:user headers:self.mHeaders listener:self];
    
}


- (void) oauthThreadMethod: (id) param {
    NSDictionary * dParam = (NSDictionary *)param;
    NSString * userName = [dParam valueForKeyPath:@"userName"];
    NSString * userPassword = [dParam valueForKeyPath:@"userPassword"];
    
    [self loginWith:userName password:userPassword];
}

- (void) startOauthByName: (NSString*) userName password: (NSString*) userPassword listener: (id<LoginListener> ) loginListener {
    
    self.mLoginListener = loginListener;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:userName forKey:@"userName"];
    [param setValue:userPassword forKey:@"userPassword"];
    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(oauthThreadMethod:)
                                                   object:param];
    [myThread start];
}

- (void) getCodeThreadMethod {
    [self.mFMOauthHttpClient getCodeWithUrl:[self.mConfig getCodeUrl] headers:self.mHeaders listener:self];
}
- (void) getCode {
    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(getCodeThreadMethod)
                                                   object:nil];
    [myThread start];
}

- (void) getAccessTokenThreadMethod: (NSString*) code {
    [self.mFMOauthHttpClient getAccessTokenWithUrl:[self.mConfig getAccessTokenUrl:code] headers:self.mHeaders listener:self];
}
- (void) getAccessToken: (NSString*) code {
    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(getAccessTokenThreadMethod:)
                                                   object:code];
    [myThread start];

}


- (void) getRefreshTokenThreadMethod: (NSString*) refreshToken {
    [self.mFMOauthHttpClient refreshAccessTokenWithUrl:[self.mConfig getRefreshTokenUrl:refreshToken] headers:self.mHeaders listener:self];
    
}



- (void) refreshToken: (NSString*) refreshToken listener: (id<LoginListener>) refreshListener {
    self.mLoginListener = refreshListener;
    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(getRefreshTokenThreadMethod:)
                                                   object:refreshToken];
    [myThread start];
}
//
- (OAuthUserInfo*) getUserInfo {
    return self.mUserInfo;
}


- (void) onOAuthSuccess: (int) requestType : (id) result {
    NSDictionary * dicResult = nil;
    NSString * code = nil;
    FMToken* token = nil;
    switch(requestType) {
        case OAUTH_REQUEST_TYPE_LOGIN:
            dicResult = result;
            if(self.mUserInfo) {
                self.mUserInfo = nil;
            }
            if ([(NSString *)[dicResult valueForKeyPath:@"status"] isEqualToString:@"success"]) {
                _mUserInfo = [[OAuthUserInfo alloc] init];
                NSDictionary * data = [dicResult valueForKeyPath:@"data"];
                NSNumber * tmpNumber;
                tmpNumber = [data valueForKeyPath:@"userId"];
                _mUserInfo.userId = [tmpNumber integerValue];
                tmpNumber = [data valueForKeyPath:@"userType"];
                _mUserInfo.userType = [tmpNumber integerValue];
                [self getCode];
            } else if([(NSString *)[dicResult valueForKeyPath:@"status"] isEqualToString:@"error"]) {
                NSError* error = [[NSError alloc] initWithDomain:errorDomain code:OAUTH_ERROR_LOGIN userInfo:result];
                if(self.mLoginListener) {
                    [self.mLoginListener onLoginError:error];
                }

            }
            break;
        case OAUTH_REQUEST_TYPE_GET_CODE:
            code = result;
            if(code) {
                [self getAccessToken:code];
            } else {
                NSError* error = [[NSError alloc] initWithDomain:errorDomain code:OAUTH_ERROR_LOGIN userInfo:result];
                if(self.mLoginListener) {
                    [self.mLoginListener onLoginError:error];
                }
            }
            break;
        case OAUTH_REQUEST_TYPE_GET_ACCESS_TOKEN:
            dicResult = result;
            token = [[FMToken alloc] initWithJsonObject:dicResult];
            if([token isSessionValid]) {
                token.mUid = [[NSString alloc] initWithFormat:@"%ld", self.mUserInfo.userId];
                [self.mKeeper keepAccessToken:token];
            } else {
                NSError* error = [[NSError alloc] initWithDomain:errorDomain code:OAUTH_ERROR_LOGIN userInfo:result];
                if(self.mLoginListener) {
                    [self.mLoginListener onLoginError:error];
                }
            }
            if(self.mLoginListener) {
                [self.mLoginListener onLoginSuccess:token];
            }
            break;
        case OAUTH_REQUEST_TYPE_REFRESH_ACCESS_TOKEN:
            dicResult = result;
            token = [[FMToken alloc] initWithJsonObject:dicResult];
            if([token isSessionValid]) {
                token.mUid = [[NSString alloc] initWithFormat:@"%ld", self.mUserInfo.userId];
                [self.mKeeper keepAccessToken:token];
            }
            if(self.mLoginListener) {
                [self.mLoginListener onLoginSuccess:token];
            }
            break;
    }
}

- (void) onOAuthError: (int) requestType : (NSError *) error {
    if(_mLoginListener && [_mLoginListener respondsToSelector:@selector(onLoginError:)]) {
        [_mLoginListener onLoginError:error];
    }
}

- (void) onOAuthCancel: (int) requestType {
    if(self.mLoginListener && [_mLoginListener respondsToSelector:@selector(onLoginCancel)]) {
        [self.mLoginListener onLoginCancel];
    }
}

@end
