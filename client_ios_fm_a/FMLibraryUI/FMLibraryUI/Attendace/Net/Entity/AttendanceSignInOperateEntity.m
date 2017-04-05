//
//  AttendanceSignInOperateEntity.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/23.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceSignInOperateEntity.h"
#import "MJExtension.h"
#import "SystemConfig.h"
#import "AttendanceConfig.h"
#import "FMUtilsPackages.h"

//签入
@implementation AttendanceOperateSignRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        _location = [[AttendanceLocation alloc] init];
    }
    return self;
}

- (NSString *)getUrl {
    NSString * url = [self wrapUrl:[NSString stringWithFormat:@"%@%@",[SystemConfig getServerAddress],ATTENDANCE_SIGN_OPERATE_URL]];
    return url;
}
@end

@implementation AttendanceOperateSignResponse
@end

