//
//  OauthHttpClient.h
//  hello
//
//  Created by 杨帆 on 15/3/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UrlRewriter.h"
#import "AFNetworking.h"
#import "OAuthListener.h"

@interface OauthHttpClient : NSObject

- (instancetype) init;

- (instancetype) initWithUrlReWriter: (NSObject<UrlRewriter> *) urlReWriter;

- (NSString*) loginWithUrl: (NSString*) strUrl
                      body: (NSDictionary*) content
                   headers: (NSDictionary *) mHeaders
                  listener: (NSObject<OAuthListener> *)listener;

- (NSString*) getCodeWithUrl: (NSString*) strUrl
                     headers: (NSDictionary*) headers
                    listener: (NSObject<OAuthListener> *)listener;

- (NSString*) getAccessTokenWithUrl: (NSString*) strUrl
                            headers: (NSDictionary*) headers
                           listener: (NSObject<OAuthListener> *)listener;

- (NSString*) refreshAccessTokenWithUrl: (NSString*) strUrl
                                headers: (NSDictionary*) headers
                               listener: (NSObject<OAuthListener> *)listener;

- (void) checkSessionCookie: (NSDictionary*) headers;

- (NSDictionary*) addSessionCookie: (NSDictionary*) headers;

@end


extern NSString * const HEADER_CONTENT_TYPE;
extern NSString * const SET_COOKIE_KEY;
extern NSString * const COOKIE_KEY;
extern NSString * const SESSION_COOKIE;