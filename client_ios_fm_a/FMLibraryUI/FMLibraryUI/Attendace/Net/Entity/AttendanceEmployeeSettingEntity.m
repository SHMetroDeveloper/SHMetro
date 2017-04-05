//
//  AttendanceEmployeeSettingEntity.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/26.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceEmployeeSettingEntity.h"
#import "MJExtension.h"
#import "SystemConfig.h"
#import "AttendanceConfig.h"
#import "FMUtilsPackages.h"

//工作组信息
@implementation AttendanceEmployeeWorkTeamRequestParam
- (NSString *)getUrl {
    NSString * url = [self wrapUrl:[NSString stringWithFormat:@"%@%@",[SystemConfig getServerAddress],ATTENDANCE_EMPLOYEE_SETTING_WORKTEAM_URL]];
    return url;
}
@end

@implementation AttendanceEmployeeWorkTeamEntity
@end

@implementation AttendanceEmployeeWorkTeamResponse
+ (NSDictionary *) mj_objectClassInArray {
    return @{@"data" : @"AttendanceEmployeeWorkTeamEntity"
             };
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [NSMutableArray new];
    }
    return self;
}
@end


//组内人员
@implementation AttendanceEmployeeWorkEmployeeRequestParam
- (NSString *)getUrl {
    NSString * url = [self wrapUrl:[NSString stringWithFormat:@"%@%@",[SystemConfig getServerAddress],ATTENDANCE_EMPLOYEE_SETTING_EMPLOYEE_URL]];
    return url;
}
@end

@implementation AttendanceEmployeeWorkEmployeeResponse
+ (NSDictionary *) mj_objectClassInArray {
    return @{@"data" : @"AttendanceConfigurePerson"
             };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [NSMutableArray new];
    }
    return self;
}
@end


