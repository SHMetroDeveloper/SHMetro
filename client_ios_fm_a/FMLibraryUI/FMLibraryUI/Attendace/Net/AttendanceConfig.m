//
//  AttendanceConfig.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/21.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceConfig.h"
#import "FMUtilsPackages.h"


NSString * const ATTENDANCE_SIGN_SETTING_LIST_URL = @"/m/v1/clock/setting/list";

NSString * const ATTENDANCE_SETTING_OPERATE_EMPLOYEE_URL = @"/m/v1/clock/setting/person";
NSString * const ATTENDANCE_SETTING_OPERATE_WIFI_URL = @"/m/v1/clock/setting/wifi";
NSString * const ATTENDANCE_SETTING_OPERATE_BLUETOOTH_URL = @"/m/v1/clock/setting/bluetooth";
NSString * const ATTENDANCE_SETTING_OPERATE_LOCATION_URL = @"/m/v1/clock/setting/location";

NSString * const ATTENDANCE_SIGN_OPERATE_URL = @"/m/v1/clock/sign";  //签入签出操作
//NSString * const ATTENDANCE_SIGN_OPERATE_IN_URL = @"/m/v1/clock/signin";   //签入操作
//NSString * const ATTENDANCE_SIGN_OPERATE_OUT_URL = @"/m/v1/clock/signout";   //签出操作

NSString * const ATTENDANCE_SIGNIN_HISTORY_URL = @"/m/v1/clock/history";

NSString * const ATTENDANCE_EMPLOYEE_SETTING_WORKTEAM_URL = @"/m/v1/clock/person/workteam";
NSString * const ATTENDANCE_EMPLOYEE_SETTING_EMPLOYEE_URL = @"/m/v1/clock/person/members";


@implementation AttendanceConfig

+ (NSString *) getSignInTypeStrDescByType:(AttendanceSignInType) type {
    NSString *strDesc = @"";
    switch (type) {
        case ATTENDANCE_SIGN_IN_TYPE_WIFI:
            strDesc = @"Wi-Fi";
            break;
            
        case ATTENDANCE_SIGN_IN_TYPE_BLU:
            strDesc = @"Bluetooth";
            break;
            
        case ATTENDANCE_SIGN_IN_TYPE_GPS:
            strDesc = @"GPS";
            break;
    }
    
    return strDesc;
}

+ (UIImage *) getSignInTypeImageDescByType:(AttendanceSignInType) type {
    UIImage *img = [[FMTheme getInstance]  getImageByName:@"Sign_Type_Icon_WiFi"];
    switch (type) {
        case ATTENDANCE_SIGN_IN_TYPE_WIFI:
            img = [[FMTheme getInstance]  getImageByName:@"Sign_Type_Icon_WiFi"];
            break;
            
        case ATTENDANCE_SIGN_IN_TYPE_BLU:
            img = [[FMTheme getInstance]  getImageByName:@"Sign_Type_Icon_Bluetooth"];
            break;
            
        case ATTENDANCE_SIGN_IN_TYPE_GPS:
            img = [[FMTheme getInstance]  getImageByName:@"Sign_Type_Icon_GPS"];
            break;
    }
    
    return img;
}

@end
