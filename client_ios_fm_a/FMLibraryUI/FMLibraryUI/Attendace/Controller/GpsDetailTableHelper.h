//
//  GpsDetailTableHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/27/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, GpsDetailTableEventType) {
    GPS_DETAIL_TABLE_EVENT_TYPE_UNKNOW,
    GPS_DETAIL_TABLE_EVENT_DELETE,  //删除位置
    GPS_DETAIL_TABLE_EVENT_SELECT_ACCURACY, //选择范围
    GPS_DETAIL_TABLE_EVENT_STATE_CHANGE,  //更改签到地址状态
};

@interface GpsDetailTableHelper : NSObject <UITableViewDelegate, UITableViewDataSource>

- (instancetype) init;

@property (nonatomic, assign) BOOL isEditable;

//设置签到地址
- (void) setGpsWithArray:(NSMutableArray *) array;
//设置精确范围
- (void) setAccuracy:(NSInteger)accuracy;

- (NSInteger) getGpsCount;

//- (void) addGpsWithArray:(NSMutableArray *) array;
//- (void) deleteLocation:(NSInteger) position;
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;
@end

