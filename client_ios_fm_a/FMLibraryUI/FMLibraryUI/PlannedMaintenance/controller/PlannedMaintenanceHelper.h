//
//  PlannedMaintenanceHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/27.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, MaintenanceCalendarEventType) {
    PM_CALENDAR_EVENT_UNKNOW,
    PM_CALENDAR_EVENT_SHOW_DETAIL,
    PM_CALENDAR_EVENT_TIME_CHANGE,
    PM_CALENDAR_EVENT_SELECT_DATE,
};

@interface PlannedMaintenanceHelper : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype) initWithContext:(BaseViewController *) context;


- (void) setDataWithArray:(NSMutableArray *) dataArray;

- (void) clearAll;

- (NSInteger) getCount;

//获取开始时间
- (NSNumber *) getTimeStart;

//获取结束时间
- (NSNumber *) getTimeEnd;

//获取选中的时间
- (NSDate *) getDateSelected;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
