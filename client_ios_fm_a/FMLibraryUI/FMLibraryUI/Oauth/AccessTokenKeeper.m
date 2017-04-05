//
//  AccessTokenKeeper.m
//  hello
//
//  Created by 杨帆 on 15/3/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "AccessTokenKeeper.h"
#import "BasePreference.h"

@implementation AccessTokenKeeper

- (instancetype) initWithName: (NSString *) name {
    self = [super init];
    if(!self) {
        return nil;
    }
    self.OAUTH_UID = [[NSString alloc] initWithFormat:@"uid-%@", name];
    self.OAUTH_TOKEN = [[NSString alloc] initWithFormat:@"access_token-%@", name];
    self.OAUTH_REFRESH_TOKEN = [[NSString alloc] initWithFormat:@"refresh_token-%@", name];
    self.OAUTH_EXPIRES_TIME = [[NSString alloc] initWithFormat:@"expires_time-%@", name];
    
    return self;
}

- (void) keepAccessToken: (Token *) token {
    [BasePreference saveUserInfoKey:self.OAUTH_UID stringValue:token.mUid];
    [BasePreference saveUserInfoKey:self.OAUTH_TOKEN stringValue:token.mAccessToken];
    [BasePreference saveUserInfoKey:self.OAUTH_REFRESH_TOKEN stringValue:token.mRefreshToken];
    [BasePreference saveUserInfoKey:self.OAUTH_EXPIRES_TIME numberValue:@(token.mExpiresTime)];
}

- (Token *) readAccessToken {
    Token * res = [[Token alloc] init];
    res.mAccessToken = [BasePreference getUserInfoString:self.OAUTH_TOKEN];
    res.mRefreshToken = [BasePreference getUserInfoString:self.OAUTH_REFRESH_TOKEN];
    res.mExpiresTime = [[BasePreference getUserInfoString:self.OAUTH_EXPIRES_TIME] integerValue];
    res.mUid = [BasePreference getUserInfoString:self.OAUTH_UID];
    return res;
}

- (NSString *) getUid {
    NSString * res = [BasePreference getUserInfoString:self.OAUTH_UID];
    return res;
}

- (void) clear {
    
}

@end
