//
//  FMConfig.m
//  hello
//
//  Created by 杨帆 on 15/3/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "FMConfig.h"

@implementation FMConfig

- (NSString*) getCodeUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=code", self.codeUrl, self.appKey, self.codeRedirectUrl];
    return res;
}

- (NSString*) getAccessTokenUrl:(NSString*) code {
    NSString* res = [[NSString alloc] initWithFormat:@"%@?client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@", self.accessTokenUrl, self.appKey, self.appSecret, self.accessTokenRedirectUrl, code];
    return res;
}

- (NSString*) getRefreshTokenUrl:(NSString*) refreshToken {
    NSString* res = [[NSString alloc] initWithFormat:@"%@?client_id=%@&client_secret=%@&grant_type=refresh_token&accessTokenRedirectUrl=%@&refresh_token=%@", self.refreshTokenUrl, self.appKey, self.appSecret, self.accessTokenRedirectUrl, refreshToken];
    return res;
}

@end