//
//  OAuthFM.h
//  hello
//
//  Created by 杨帆 on 15/3/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthConfig.h"
#import "Token.h"
#import "LoginListener.h"
#import "OAuthUserInfo.h"

@interface OAuthFM : NSObject

- (instancetype) initWithAppKey:(NSString *) appkey
                      appScrete: (NSString*) appScrete
                      serverUrl: (NSString*) serverUrl
                       deviceId: (NSString*) deviceId;

- (OAuthConfig *) getConfig;

- (Token *) getToken;

- (void) clearToken;

- (void) startOauthByName: (NSString*) userName password: (NSString*) userPassword listener: (id<LoginListener>) loginListener;

- (void) refreshToken: (NSString*) refreshToken listener: (id<LoginListener>) loginListener;

- (OAuthUserInfo*) getUserInfo;




@end

typedef enum {
    OAUTH_ERROR_LOGIN = 0x100,
    OAUTH_ERROR_REQUEST_CODE = 0x200,
    OAUTH_ERROR_REQUEST_TOKEN = 0x300
} OauthErrorCode;
