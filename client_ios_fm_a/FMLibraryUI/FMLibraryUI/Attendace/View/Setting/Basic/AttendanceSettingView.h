//
//  AttendanceSettingView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/19.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendanceSettingEntity.h"

typedef NS_ENUM (NSInteger, AttendanceSettingActionEventType) {
    ATTENDANCE_SETTING_ACTION_TYPE_EMPLOYEE_EDIT,   //签到人员
    ATTENDANCE_SETTING_ACTION_TYPE_LOCATION_EDIT,   //签到地理位置
    ATTENDANCE_SETTING_ACTION_TYPE_WIFI_EDIT,       //签到Wi-Fi
    ATTENDANCE_SETTING_ACTION_TYPE_BLUETOOTH_EDIT,  //签到蓝牙
    
    ATTENDANCE_SETTING_ACTION_TYPE_EMPLOYEE_DETAIL,   //查看签到人员
    ATTENDANCE_SETTING_ACTION_TYPE_LOCATION_DETAIL,   //查看签到人员
    ATTENDANCE_SETTING_ACTION_TYPE_WIFI_DETAIL,       //查看Wi-Fi
    ATTENDANCE_SETTING_ACTION_TYPE_BLUETOOTH_DETAIL,  //查看蓝牙
};

typedef void(^AttendanceSettingActionBlock)(AttendanceSettingActionEventType type);

@interface AttendanceSettingView : UITableView

@property (nonatomic, copy) AttendanceSettingActionBlock actionBlock;
@property (nonatomic, strong) AttendanceSettingDetail *settingDetail;  //设置参数

@end
