//
//  PatrolTaskQueryFilterViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  巡检历史记录过滤器页面

#import "BaseViewController.h"
#import "MMPNavigationProtocols.h"
#import "OnListItemButtonClickListener.h"
#import "OnMessageHandleListener.h"

#import "CheckableButton.h"
#import "OnClickListener.h"
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, PatrolTaskQueryFilterEventType){
    PATROL_FILTER_EVENT_TYPE_FILTERDATA = 0,    //筛选信息发送
//    PATROL_FILTER_EVENT_TYPE_DATAPICKER = 1,    //日期选择
//    PATROL_FILTER_EVENT_TYPE_DIALOG = 2,    //时间信息不正确
};

typedef NS_ENUM(NSInteger, PatrolTaskTimePickerType){
    PATROL_TASK_TIME_PICKER_UNKNOW = 0,
    PATROL_TASK_TIME_PICKER_START = 1,
    PATROL_TASK_TIME_PICKER_END = 2,
};

@interface PatrolTaskQueryFilterViewController : BaseViewController <MMPMainViewDelegate, UITableViewDataSource, UITableViewDelegate, OnClickListener, OnStateChangeListener, OnMessageHandleListener, OnItemClickListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

//设置开始时间和结束时间
- (void) setTimeStart:(NSNumber *) timeStart timeEnd:(NSNumber *) timeEnd;

@property (nonatomic, assign) id<MMPMainViewDelegate> ldelegate;

@end
