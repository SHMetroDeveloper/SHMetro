//
//  AttendanceEntity.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/18.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceSettingEntity.h"
#import "MJExtension.h"
#import "SystemConfig.h"
#import "AttendanceConfig.h"
#import "FMUtilsPackages.h"

@implementation AttendanceSettingDetailListRequestParam
- (NSString *)getUrl {
    NSString * url = [self wrapUrl:[NSString stringWithFormat:@"%@%@",[SystemConfig getServerAddress],ATTENDANCE_SIGN_SETTING_LIST_URL]];
    return url;
}
@end

//签到WiFi
@implementation AttendanceConfigureWiFi
@end

//签到蓝牙
@implementation AttendanceConfigureBluetooth
@end

//地理位置信息
@implementation AttendanceLocation
@end

//签到人信息
@implementation AttendanceConfigurePerson
@end

//签到坐标
@implementation AttendanceConfigureGPS
+ (NSDictionary *) mj_objectClassInArray {
    return @{@"locations" : @"AttendanceLocation"
             };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _locations = [NSMutableArray new];
    }
    return self;
}
@end

@implementation AttendanceSettingDetail
+ (NSDictionary *) mj_objectClassInArray {
    return @{@"person" : @"AttendanceConfigurePerson",
             @"wifi" : @"AttendanceConfigureWiFi",
             @"bluetooth" : @"AttendanceConfigureBluetooth"
             };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _person = [NSMutableArray new];
        _wifi = [NSMutableArray new];
        _bluetooth = [NSMutableArray new];
        _gps = [[AttendanceConfigureGPS alloc] init];
    }
    return self;
}
@end


@implementation AttendanceSettingResponse
- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [[AttendanceSettingDetail alloc] init];
    }
    return self;
}

@end



