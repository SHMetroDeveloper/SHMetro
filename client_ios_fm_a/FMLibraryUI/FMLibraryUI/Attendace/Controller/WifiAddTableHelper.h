//
//  WifiAddTableHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, WifiAddTableEventType) {
    WIFI_ADD_TABLE_EVENT_TYPE_UNKNOW,
    WIFI_ADD_TABLE_EVENT_CHECK_UPDATE,
};

@interface WifiAddTableHelper : NSObject <UITableViewDelegate, UITableViewDataSource>

- (instancetype) init;

- (void) setWifi:(NSMutableArray *) wifi;

- (void) setWifiInfo:(NSMutableDictionary *) wifiDictionary;

- (NSInteger) getWifiCount;

//获取所选择的数据
- (NSMutableArray *) getSelectedWifiArray;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
