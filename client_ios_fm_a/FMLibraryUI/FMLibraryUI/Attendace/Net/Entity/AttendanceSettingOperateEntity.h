//
//  AttendanceSettingOperateEntity.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/23.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "BaseDataEntity.h"

//考勤人员操作类型
typedef NS_ENUM(NSInteger, AttendanceOperateEmployeeType) {
    ATTENDANCE_OPERATE_EMPLOYEE_TYPE_ADD = 1,   //添加
    ATTENDANCE_OPERATE_EMPLOYEE_TYPE_DELETE,   //删除
};

//wifi 操作类型
typedef NS_ENUM(NSInteger, AttendanceOperateWifiType) {
    ATTENDANCE_OPERATE_WIFI_TYPE_ADD = 1,   //添加
    ATTENDANCE_OPERATE_WIFI_TYPE_DELETE,   //删除
    ATTENDANCE_OPERATE_WIFI_TYPE_UPDATE,   //修改
};

//蓝牙操作类型
typedef NS_ENUM(NSInteger, AttendanceOperateBluetoothType) {
    ATTENDANCE_OPERATE_BLUETOOTH_TYPE_ADD = 1,   //添加
    ATTENDANCE_OPERATE_BLUETOOTH_TYPE_DELETE,   //删除
    ATTENDANCE_OPERATE_BLUETOOTH_TYPE_UPDATE,   //修改
};

//位置操作类型
typedef NS_ENUM(NSInteger, AttendanceOperateLocationType) {
    ATTENDANCE_OPERATE_LOCATION_TYPE_ADD = 1,   //添加
    ATTENDANCE_OPERATE_LOCATION_TYPE_DELETE,   //删除
    ATTENDANCE_OPERATE_LOCATION_TYPE_UPDATE,   //修改
};

@interface AttendanceOperateEmployeeRequestParam : BaseRequest
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSMutableArray *person;   //存的只有ID
- (NSString *)getUrl;
@end

@interface AttendanceOperateEmployeeResponse : BaseResponse
@end


//---------------------------------------------------------------------


@interface AttendanceOperateWiFi : NSObject
@property (nonatomic, strong) NSNumber * wifiId;    //签到widi 的ID
@property (nonatomic, strong) NSString * name;          //wif名称
@property (nonatomic, strong) NSString * mac;          //wifi地址
@property (nonatomic, assign) BOOL enable;              //是否启用
@end

@interface AttendanceOperateWiFiRequestParam : BaseRequest
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSMutableArray *wifi; //存的是wifi entity //"wifiId":0, "name":"", "mac":"", "enable":0
- (NSString *)getUrl;
@end

@interface AttendanceOperateWiFiResponse : BaseResponse
@property (nonatomic, strong) NSMutableArray * data;
@end


//---------------------------------------------------------------------

@interface AttendanceOperateBluetooth : NSObject
@property (nonatomic, strong) NSNumber * bluetoothId;    //签到蓝牙ID
@property (nonatomic, strong) NSString * name;          //蓝牙名称
@property (nonatomic, strong) NSString * mac;          //蓝牙地址
@property (nonatomic, assign) BOOL enable;              //是否启用
@end

@interface AttendanceOperateBluetoothRequestParam : BaseRequest
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSMutableArray *bluetooth; //存的是bluetooth entity //"bluetoothId":0, "name":"", "mac":"", "enable":0
- (NSString *)getUrl;
@end

@interface AttendanceOperateBluetoothResponse : BaseResponse
@property (nonatomic, strong) NSMutableArray * data;
@end


//---------------------------------------------------------------------
@interface AttendanceOperateLocation : NSObject
@property (nonatomic, strong) NSNumber * locationId;    //签到位置ID
@property (nonatomic, strong) NSString * name;          //位置名称
@property (nonatomic, strong) NSString * desc;          //位置描述
@property (nonatomic, strong) NSString * lat;           //纬度
@property (nonatomic, strong) NSString * lon;           //经度
@property (nonatomic, assign) BOOL enable;              //是否启用
@end

@interface AttendanceOperateLocationRequestParam : BaseRequest
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger accuracy;
@property (nonatomic, strong) NSMutableArray *location; //存的是location entity //"locationId":0, "name":"", "lat":"", "lon":"", "mac":"", "enable":0
- (NSString *)getUrl;
@end

@interface AttendanceOperateLocationResponse : BaseResponse
@property (nonatomic, strong) NSMutableArray * data;
@end


