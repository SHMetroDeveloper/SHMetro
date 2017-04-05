//
//  FMToken.m
//  hello
//
//  Created by 杨帆 on 15/3/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "FMToken.h"

@implementation FMToken

- (instancetype) initWithJsonObject:(NSDictionary *) object {
    self = [super init];
    if(!self) {
        return nil;
    }
    self.mAccessToken = [object valueForKeyPath:@"access_token"];
    self.mExpiresIn = (NSInteger)[object valueForKeyPath:@"expires_in"];
    self.mRefreshToken = [object valueForKeyPath:@"refresh_token"];
    self.mUid = [object valueForKeyPath:@"uid"];
    return self;
}

@end
