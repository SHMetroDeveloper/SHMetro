//
//  DispachTaskAlertContentView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/24.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"
#import "OnMessageHandleListener.h"
#import "WorkOrderLaborerDispachEntity.h"
#import "OnClickListener.h"

typedef NS_ENUM(NSInteger, DispachTaskOperateType) {
    DISPACH_TASK_ALERT_TYPE_UNKNOW,
    DISPACH_TASK_ALERT_TYPE_DELETE_LABORER,
    DISPACH_TASK_ALERT_TYPE_SELECT_LABORER,
    DISPACH_TASK_ALERT_TYPE_LEADER_CHANGE,
    DISPACH_TASK_ALERT_TYPE_SET_TIME_START,
    DISPACH_TASK_ALERT_TYPE_SET_TIME_END,
    DISPACH_TASK_ALERT_TYPE_SET_TIME_USED,
    DISPACH_TASK_ALERT_TYPE_DISPACH,
};

@interface DispachTaskAlertContentView : UIView<UITableViewDataSource, UITableViewDelegate, OnClickListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

//- (NSNumber *) getSelectLaborerId;
//- (NSNumber *) getStartTime;
//- (NSNumber *) getEndTime;
- (NSNumber *) getTimeUsed;
- (NSInteger) getLeaderIndex;


- (void) addLaborer:(WorkOrderLaborerDispach *) laborer;
- (void) setStartTime:(NSNumber *) timeStart;
- (void) setEndTime:(NSNumber *) timeEnd;
- (void) setUsedTime:(NSNumber *) timeUsed;
- (void) clearInput;


- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
