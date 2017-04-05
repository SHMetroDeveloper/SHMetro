//
//  UserEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/24.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "UserEntity.h"
#import "UserServerConfig.h"


@interface UserEntity ()

@end

@implementation UserEntity

@end

@implementation UserInfo

- (instancetype) init {
    
    self = [super init];
    if (self) {
        
        _location = [[Position alloc] init];
    }
    
    return self;
}

@end

@implementation UserInfoResponse

@end


@implementation UserGroup

@end
