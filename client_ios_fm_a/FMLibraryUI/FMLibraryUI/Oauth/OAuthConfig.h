//
//  OAuthConfig.h
//  hello
//
//  Created by 杨帆 on 15/3/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAuthConfig : NSObject

@property (readwrite, nonatomic, copy) NSString* appKey;
@property (readwrite, nonatomic, copy) NSString* appSecret;
@property (readwrite, nonatomic, copy) NSString* codeUrl;
@property (readwrite, nonatomic, copy) NSString* accessTokenUrl;
@property (readwrite, nonatomic, copy) NSString* refreshTokenUrl;
@property (readwrite, nonatomic, copy) NSString* codeRedirectUrl;
@property (readwrite, nonatomic, copy) NSString* accessTokenRedirectUrl;
@property (readwrite, nonatomic, copy) NSString* refreshTokenRedirectUrl;

- (instancetype) initWithAppKey:(NSString*) appKey
                      appSecret:(NSString*) appSecret
                        codeUrl:(NSString*) codeUrl
                 accessTokenUrl:(NSString*) accessTokenUrl
                refreshTokenUrl:(NSString*) refreshTokenUrl
                codeRedirectUrl:(NSString*) codeRedirectUrl
         accessTokenRedirectUrl:(NSString*) accessTokenRedirectUrl
        refreshTokenRedirectUrl:(NSString*) refreshTokenRedirectUrl;


@end