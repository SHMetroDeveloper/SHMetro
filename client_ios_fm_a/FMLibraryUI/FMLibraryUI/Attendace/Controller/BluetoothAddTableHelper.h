//
//  BluetoothAddTableHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"
#import "AttendanceSettingEntity.h"

typedef NS_ENUM(NSInteger, BluetoothAddTableEventType) {
    BLUETOOTH_ADD_TABLE_EVENT_TYPE_UNKNOW,
    BLUETOOTH_ADD_TABLE_EVENT_CHECK_UPDATE,
};

@interface BluetoothAddTableHelper : NSObject <UITableViewDelegate, UITableViewDataSource>

- (instancetype) init;

- (void) setBluetooth:(NSMutableArray *) bluetooth;

- (void) addBluetooth:(AttendanceConfigureBluetooth *) bluetooth;

- (NSInteger) getBluetoothCount;
//获取所选择的数据
- (NSMutableArray *) getSelectedBluetoothArray;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end

