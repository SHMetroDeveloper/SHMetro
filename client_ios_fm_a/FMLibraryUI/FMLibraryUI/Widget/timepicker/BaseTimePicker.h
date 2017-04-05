//
//  BaseTimePicker.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/21.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, BaseTimePickerType) {
    BASE_TIME_PICKER_DAY,       //选择年月日
    BASE_TIME_PICKER_MONTH,     //选择年月
    BASE_TIME_PICKER_MINUTE,    //选择年月日时分
//    BASE_TIME_PICKER_DAY_WITHOUT_YEAR,       //选择月日
};

typedef NS_ENUM(NSInteger, BaseTimePickerActionType) {
    BASE_TIME_PICKER_ACTION_CANCEL, //取消
    BASE_TIME_PICKER_ACTION_OK,     //确定
};

@interface BaseTimePicker : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setPickerType:(BaseTimePickerType) type;

//设置参考日期
- (void) setCenterDate:(NSNumber *) date;

//设置最小边界值
- (void) setMinDate:(NSNumber *) minDate;

//设置最大边界值
- (void) setMaxDate:(NSNumber *) maxDate;

//获取选中的时间
- (NSNumber *) getSelectTime;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

@end
