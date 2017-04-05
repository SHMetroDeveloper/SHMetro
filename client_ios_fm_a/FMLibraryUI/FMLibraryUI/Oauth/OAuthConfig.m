//
//  OAuthConfig.m
//  hello
//
//  Created by 杨帆 on 15/3/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "OAuthConfig.h"

@implementation OAuthConfig

- (instancetype) initWithAppKey:(NSString*) appKey
appSecret:(NSString*) appSecret
codeUrl:(NSString*) codeUrl
accessTokenUrl:(NSString*) accessTokenUrl
refreshTokenUrl:(NSString*) refreshTokenUrl
codeRedirectUrl:(NSString*) codeRedirectUrl
accessTokenRedirectUrl:(NSString*) accessTokenRedirectUrl
        refreshTokenRedirectUrl:(NSString*) refreshTokenRedirectUrl {
    self = [super init];
    if(!self) {
        return nil;
    }
    self.appKey = appKey;
    self.appSecret = appSecret;
    self.codeUrl = codeUrl;
    self.accessTokenUrl = accessTokenUrl;
    self.refreshTokenUrl = refreshTokenUrl;
    self.codeRedirectUrl = codeRedirectUrl;
    self.accessTokenRedirectUrl = accessTokenRedirectUrl;
    self.refreshTokenRedirectUrl = refreshTokenRedirectUrl;
    return self;
}

@end