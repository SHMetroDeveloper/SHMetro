//
//  AttendanceDbHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 10/9/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "DBHelper.h"
#import "AttendanceSettingEntity.h"
#import "DBSignPerson+CoreDataClass.h"
#import "DBSignWifi+CoreDataClass.h"
#import "DBSignBluetooth+CoreDataClass.h"
#import "DBSignLocation+CoreDataClass.h"



@interface AttendanceDbHelper : DBHelper

+ (instancetype) getInstance;

//签到人员
- (BOOL) isSignPersonExist:(NSNumber*) emId;
- (BOOL) addSignPerson:(AttendanceConfigurePerson*) person;
- (BOOL) addSignPersonWithArray:(NSArray *) array;
//设置签到人员的的类型和状态
- (BOOL) setSignType:(NSInteger) type status:(NSInteger) status ofPerson:(NSNumber *) emId;
//根据ID删除指定报障设备
- (BOOL) deleteSignPersonById:(NSNumber*) emId;
//删除所有签到人员信息
- (BOOL) deleteAllSignPerson;
//查询所有的人员(DBSignPerson)
- (NSMutableArray*) queryAllDbSignPerson;
//查询所有签到人员(AttendanceConfigurePerson)
- (NSMutableArray*) queryAllSignPerson;


//签到wifi
- (BOOL) isSignWifiExist:(NSNumber*) wifiId;
- (BOOL) isSignWifiExistByMac:(NSString*) mac;   //
- (BOOL) addSignWifi:(AttendanceConfigureWiFi*) wifi;
- (BOOL) addSignWifiWithArray:(NSArray *) array;
//设置签到wifi的状态
- (BOOL) setSignWifi:(NSNumber *) wifiId status:(BOOL) enable;
//根据ID删除指定数据
- (BOOL) deleteSignWifiById:(NSNumber*) wifiId;
//删除所有WiFi数据
- (BOOL) deleteAllSignWifi;
//查询报障中的所有签到wifi(DBSignWifi)
- (NSMutableArray*) queryAllDBSignWifi;
//查询报障中的所有签到wifi(AttendanceConfigureWiFi)
- (NSMutableArray*) queryAllSignWifi;

//签到蓝牙
- (BOOL) isSignBluetoothExist:(NSNumber*) bluetoothId;
- (BOOL) isSignBluetoothExistByMac:(NSString*) mac;   //
- (BOOL) addSignBluetooth:(AttendanceConfigureBluetooth*) bluetooth;
- (BOOL) addSignBluetoothWithArray:(NSArray *) array;
//设置签到蓝牙的状态
- (BOOL) setSignBluetooth:(NSNumber *) bluetoothId status:(BOOL) enable;
//根据ID删除指定数据
- (BOOL) deleteSignBluetoothById:(NSNumber*) bluetoothId;
//删除所有蓝牙数据
- (BOOL) deleteAllSignBluetooth;
//查询报障中的所有签到蓝牙(DBSignBluetooth)
- (NSMutableArray*) queryAllDBSignBluetooth;
//查询报障中的所有签到蓝牙(AttendanceConfigureBluetooth)
- (NSMutableArray*) queryAllSignBluetooth;

//签到位置
- (BOOL) isSignLocationExist:(NSNumber*) locationId;
- (BOOL) isSignLocationExistByLat:(NSString*) lat lon:(NSString *) lon andLocationName:(NSString *) name; //
- (BOOL) addSignLocation:(AttendanceLocation*) location;
- (BOOL) addSignLocationWithArray:(NSArray *) array;
//设置签到位置的状态
- (BOOL) setSignLocation:(NSNumber *) locationId status:(BOOL) enable;
//根据ID删除指定数据
- (BOOL) deleteSignLocationById:(NSNumber*) locationId;
//删除所有的地理位置信息
- (BOOL) deleteAllSignLocation;
//查询报障中的所有签到位置(DBSignLocation)
- (NSMutableArray*) queryAllDBSignLocation;
//查询报障中的所有签到位置(AttendanceLocation)
- (NSMutableArray*) queryAllSignLocation;

@end
