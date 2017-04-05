//
//  AccessTokenKeeper.h
//  hello
//
//  Created by 杨帆 on 15/3/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Token.h"

@interface AccessTokenKeeper : NSObject

@property (readwrite, nonatomic, copy) NSString * OAUTH_UID;
@property (readwrite, nonatomic, copy) NSString * OAUTH_TOKEN;
@property (readwrite, nonatomic, copy) NSString * OAUTH_REFRESH_TOKEN;
@property (readwrite, nonatomic, copy) NSString * OAUTH_EXPIRES_TIME;

//
- (instancetype) initWithName: (NSString *) name;

//保存 accessToken
- (void) keepAccessToken: (Token *) token;

//读取 accessToken
- (Token *) readAccessToken;

// 从所保存的数据中读取用户 ID
- (NSString *) getUid;

//清除所保存的数据信息
- (void) clear;

@end
