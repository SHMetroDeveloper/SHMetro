//
//  OAuthListener.h
//  供内部在获取 accesstoken 时同服务器交互的过程中使用
//
//  Created by 杨帆 on 15/3/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Token.h"

#ifndef __OAUTH_LISTENER_H_
#define __OAUTH_LISTENER_H_

@protocol OAuthListener <NSObject>

@required
- (void) onOAuthSuccess: (int) requestType : (id) result;
- (void) onOAuthError: (int) requestType : (NSError *) error;
- (void) onOAuthCancel: (int) requestType;

@end

typedef enum {
    OAUTH_REQUEST_TYPE_LOGIN = 100,
    OAUTH_REQUEST_TYPE_GET_CODE = 200,
    OAUTH_REQUEST_TYPE_GET_ACCESS_TOKEN = 300,
    OAUTH_REQUEST_TYPE_REFRESH_ACCESS_TOKEN = 400
}OAUTH_REQUEST_TYPE;

#endif

//extern int const OAUTH_REQUEST_TYPE_LOGIN;
//extern int const OAUTH_REQUEST_TYPE_GET_CODE;
//extern int const OAUTH_REQUEST_TYPE_GET_ACCESS_TOKEN;
//extern int const OAUTH_REQUEST_TYPE_REFRESH_ACCESS_TOKEN;