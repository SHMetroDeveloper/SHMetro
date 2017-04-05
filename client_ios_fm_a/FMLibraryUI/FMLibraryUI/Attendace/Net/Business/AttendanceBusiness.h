//
//  AttendanceBusiness.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/26/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "BaseBusiness.h"
#import "AttendanceSignHistoryEntity.h"
#import "AttendanceSignInOperateEntity.h"
#import "AttendanceSettingOperateEntity.h"


typedef NS_ENUM(NSInteger, AttendanceBusinessType) {
    BUSINESS_ATTENDANCE_UNKNOW,   //
    BUSINESS_ATTENDANCE_GET_SETTINGS,       //获取设置方式
    BUSINESS_ATTENDANCE_GET_GROUPS,         //获取工作组
    BUSINESS_ATTENDANCE_GET_EMPLOYEE,       //获取组内人员
    BUSINESS_ATTENDANCE_GET_SIGN_SETTING_LIST,       //获取签到设置按钮
    BUSINESS_ATTENDANCE_GET_SIGN_HISTORY,       //获取签到历史记录
    
    BUSINESS_ATTENDANCE_OPERATE_SIGN_IN,       //签出
    BUSINESS_ATTENDANCE_OPERATE_SIGN_OUT,       //签入
    
    BUSINESS_ATTENDANCE_SETTING_EMPLOYEE,       //设置签到人员
    BUSINESS_ATTENDANCE_SETTING_WIFI,       //设置签到位置
    BUSINESS_ATTENDANCE_SETTING_BLUETOOTH,       //设置签到蓝牙
    BUSINESS_ATTENDANCE_SETTING_LOCATION,       //设置签到位置
};

@interface AttendanceBusiness : BaseBusiness
    
//获取业务的实例对象
+ (instancetype) getInstance;
    
//获取工作组
- (void) getGroupsSuccess:(business_success_block) success fail:(business_failure_block) fail;
    
//获取工作组内人员， wtId 值为空时获取无组人员
- (void) getEmployeeofGroup:(NSNumber *) wtId success:(business_success_block) success fail:(business_failure_block) fail;

//获取签到配置信息
- (void) getSignSettingInfoSuccess:(business_success_block) success fail:(business_failure_block) fail;

//获取签到历史记录
- (void) getSignHistoryByParam:(AttendanceSignHistoryRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail;

//签入操作
- (void) attendanceOperateSign:(AttendanceOperateSignRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//签出操作
//- (void) attendanceOperateSignOut:(AttendanceOperateSignOutRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//考勤人员
- (void) setRuleOfEmployee:(NSMutableArray *) array type:(AttendanceOperateEmployeeType) type success:(business_success_block) success fail:(business_failure_block) fail;


//设置签到 wifi
- (void) setRuleOfWifi:(NSMutableArray *) wifiArray sType:(AttendanceOperateWifiType) type success:(business_success_block) success fail:(business_failure_block) fail;

//设置签到 蓝牙
- (void) setRuleOfBluetooth:(NSMutableArray *) bluetoothArray sType:(AttendanceOperateBluetoothType) type success:(business_success_block) success fail:(business_failure_block) fail;

//设置签到 地址
- (void) setRuleOfLocation:(NSMutableArray *) array sType:(AttendanceOperateLocationType) type accuracy:(NSInteger) accuracy success:(business_success_block) success fail:(business_failure_block) fail;


@end



