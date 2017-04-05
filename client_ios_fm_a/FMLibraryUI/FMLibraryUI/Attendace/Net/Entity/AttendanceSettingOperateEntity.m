//
//  AttendanceSettingOperateEntity.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/23.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceSettingOperateEntity.h"
#import "SystemConfig.h"
#import "AttendanceConfig.h"
#import "MJExtension.h"
#import "FMUtilsPackages.h"

@implementation AttendanceOperateEmployeeRequestParam
- (NSString *)getUrl {
    NSString * url = [self wrapUrl:[NSString stringWithFormat:@"%@%@",[SystemConfig getServerAddress],ATTENDANCE_SETTING_OPERATE_EMPLOYEE_URL]];
    return url;
}
@end

@implementation AttendanceOperateEmployeeResponse
@end


//---------------------------------------------------------------------
@implementation AttendanceOperateWiFi
@end

@implementation AttendanceOperateWiFiRequestParam
- (NSString *)getUrl {
    NSString * url = [self wrapUrl:[NSString stringWithFormat:@"%@%@",[SystemConfig getServerAddress],ATTENDANCE_SETTING_OPERATE_WIFI_URL]];
    return url;
}
@end

@implementation AttendanceOperateWiFiResponse
@end


//---------------------------------------------------------------------
@implementation AttendanceOperateBluetooth
@end

@implementation AttendanceOperateBluetoothRequestParam
- (NSString *)getUrl {
    NSString * url = [self wrapUrl:[NSString stringWithFormat:@"%@%@",[SystemConfig getServerAddress],ATTENDANCE_SETTING_OPERATE_BLUETOOTH_URL]];
    return url;
}
@end

@implementation AttendanceOperateBluetoothResponse
@end


//---------------------------------------------------------------------
@implementation AttendanceOperateLocation
@end

@implementation AttendanceOperateLocationRequestParam
- (NSString *)getUrl {
    NSString * url = [self wrapUrl:[NSString stringWithFormat:@"%@%@",[SystemConfig getServerAddress],ATTENDANCE_SETTING_OPERATE_LOCATION_URL]];
    return url;
}
@end

@implementation AttendanceOperateLocationResponse
@end

