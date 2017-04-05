//
//  WifiDetailTableHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, WifiDetailTableEventType) {
    WIFI_DETAIL_TABLE_EVENT_TYPE_UNKNOW,
    WIFI_DETAIL_TABLE_EVENT_DELETE,
    WIFI_DETAIL_TABLE_EVENT_ENABLE_CHANGE,  //启用切换
};

@interface WifiDetailTableHelper : NSObject <UITableViewDelegate, UITableViewDataSource>

- (instancetype) init;

@property (nonatomic, assign) BOOL isEditable;

- (NSInteger) getWifiCount;
- (void) setWifi:(NSMutableArray *) array;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;
@end
