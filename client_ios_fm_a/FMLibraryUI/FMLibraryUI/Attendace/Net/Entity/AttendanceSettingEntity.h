//
//  AttendanceEntity.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/18.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "BaseDataEntity.h"

typedef NS_ENUM(NSInteger,EmployeePriorityType) {
    EMPLOYEE_PRIORITY_TYPE_NORMAL_OFF = 0,   //0 --- 普通人员，不需要签到
    EMPLOYEE_PRIORITY_TYPE_NORMAL_ON = 1,    //1 --- 普通人员，需要签到
    EMPLOYEE_PRIORITY_TYPE_ADMIN = 2         //2 --- 签到管理员
};

typedef NS_ENUM(NSInteger,EmployeeAttendanceStatus) {
    EMPLOYEE_ATTENDANCE_OUT = 0, //离岗
    EMPLOYEE_ATTENDANCE_IN = 1   //在岗
};

@interface AttendanceSettingDetailListRequestParam: BaseRequest
- (NSString *)getUrl;
@end

//签到WiFi
@interface AttendanceConfigureWiFi : NSObject
@property (nonatomic, strong) NSNumber *wifiId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mac;
@property (nonatomic, assign) BOOL enable;
@end

//签到蓝牙
@interface AttendanceConfigureBluetooth : NSObject
@property (nonatomic, strong) NSNumber *bluetoothId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mac;
@property (nonatomic, assign) BOOL enable;
@end

//地理位置信息
@interface AttendanceLocation : NSObject
@property (nonatomic, strong) NSNumber *locationId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *lon;  //经度
@property (nonatomic, strong) NSString *lat;  //纬度
@property (nonatomic, assign) BOOL enable;
@end

//签到地理位置
@interface AttendanceConfigureGPS : NSObject
@property (nonatomic, strong) NSMutableArray *locations;  //地理位置信息
@property (nonatomic, assign) NSInteger accuracy;         //精准度
- (instancetype)init;
@end

//签到人员
@interface AttendanceConfigurePerson : NSObject
@property (nonatomic, strong) NSNumber *emId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *org;   //所在部门
@end

//detail
@interface AttendanceSettingDetail: NSObject
@property (nonatomic, assign) NSInteger type;      // 0-普通人员不需要签到 1-普通人员需要签到 2-签到管理员
@property (nonatomic, assign) NSInteger status;    // 0-离岗 1-在岗
@property (nonatomic, strong) NSMutableArray *person;
@property (nonatomic, strong) NSMutableArray *wifi;
@property (nonatomic, strong) NSMutableArray *bluetooth;
@property (nonatomic, strong) AttendanceConfigureGPS *gps;

- (instancetype)init;
@end


@interface AttendanceSettingResponse : BaseResponse
@property (nonatomic, strong) AttendanceSettingDetail * data;
- (instancetype)init;
@end




