//
//  MonthFilterTimeView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/15/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"


typedef NS_ENUM(NSInteger, MonthFilterTimeEventType) {
    MONTH_FILTER_TYPE_UNKNOW,
    MONTH_FILTER_TYPE_UPDATE,   //时间更新
    MONTH_FILTER_TYPE_SELECT_TIME,   //时间设置
};

@interface MonthFilterTimeView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setCurrentTime:(NSNumber *) time;

//获取当前时间段的起始时间
- (NSNumber *) getCurrentTimeBegin;

//获取当前时间
- (NSNumber *) getCurrentTime;

//获取当前时间段的结束时间
- (NSNumber *) getCurrentTimeEnd;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) listener;

@end
