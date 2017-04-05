//
//  LocationAddTableHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, LocationAddTableEventType) {
    LOCATION_ADD_TABLE_EVENT_TYPE_UNKNOW,
    LOCATION_ADD_TABLE_EVENT_CHECK_UPDATE,
};

@interface LocationAddTableHelper : NSObject <UITableViewDelegate, UITableViewDataSource>

- (instancetype) init;

- (void) setLocation:(NSMutableArray *) location;

//获取所选择的数据
- (NSMutableArray *) getSelectedLocationArray;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end


