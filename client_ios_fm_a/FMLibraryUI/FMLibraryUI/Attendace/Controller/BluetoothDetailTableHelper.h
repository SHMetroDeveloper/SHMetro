//
//  BluetoothDetailTableHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, BluetoothDetailTableEventType) {
    BLUETOOTH_DETAIL_TABLE_EVENT_TYPE_UNKNOW,
    BLUETOOTH_DETAIL_TABLE_EVENT_DELETE,
};

@interface BluetoothDetailTableHelper : NSObject <UITableViewDelegate, UITableViewDataSource>

- (instancetype) init;

- (void) setBluetooth:(NSMutableArray *) array;
- (void) addBluetooth:(NSMutableArray *) array;
- (NSInteger) getBluetoothCount;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;
@end

