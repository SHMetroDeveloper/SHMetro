//
//  AttendanceConfig.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/21.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AttendanceSignInType) {
    ATTENDANCE_SIGN_IN_TYPE_WIFI = 1,   //wifi签到
    ATTENDANCE_SIGN_IN_TYPE_BLU = 2,   //蓝牙签到
    ATTENDANCE_SIGN_IN_TYPE_GPS = 3,   //GPS签到
};


@interface AttendanceConfig : NSObject

+ (NSString *) getSignInTypeStrDescByType:(AttendanceSignInType) type;

+ (UIImage *) getSignInTypeImageDescByType:(AttendanceSignInType) type;

@end

extern NSString * const ATTENDANCE_SIGN_SETTING_LIST_URL; //获取设置配置信息

extern NSString * const ATTENDANCE_SETTING_OPERATE_EMPLOYEE_URL;  //添加签到人员
extern NSString * const ATTENDANCE_SETTING_OPERATE_WIFI_URL;      //添加签到WiFi
extern NSString * const ATTENDANCE_SETTING_OPERATE_BLUETOOTH_URL; //添加签到蓝牙
extern NSString * const ATTENDANCE_SETTING_OPERATE_LOCATION_URL;  //添加签到地理位置


extern NSString * const ATTENDANCE_SIGN_OPERATE_URL;   //签入操作
//extern NSString * const ATTENDANCE_SIGN_OPERATE_IN_URL;   //签入操作
//extern NSString * const ATTENDANCE_SIGN_OPERATE_OUT_URL;   //签出操作

extern NSString * const ATTENDANCE_SIGNIN_HISTORY_URL;   //获取签到历史记录

extern NSString * const ATTENDANCE_EMPLOYEE_SETTING_WORKTEAM_URL;  //工作组获取URL
extern NSString * const ATTENDANCE_EMPLOYEE_SETTING_EMPLOYEE_URL;  //组内人员获取URL



