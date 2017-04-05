//
//  FMConfig.h
//  hello
//
//  Created by 杨帆 on 15/3/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthConfig.h"

@interface FMConfig : OAuthConfig

- (NSString*) getCodeUrl;
- (NSString*) getAccessTokenUrl: (NSString*) code;
- (NSString*) getRefreshTokenUrl: (NSString*) refreshToken;


@end
