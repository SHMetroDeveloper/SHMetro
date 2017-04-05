//
//  AttendanceSignView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/19.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AttendanceSettingEntity.h"

typedef NS_ENUM(NSInteger, AttendanceSignActionType) {
    ATTENDANCE_SIGN_ACTION_EVENT_SIGN_IN,     //签入
    ATTENDANCE_SIGN_ACTION_EVENT_SIGN_OUT,    //签出
    ATTENDANCE_SIGN_ACTION_EVENT_DATE_CHANGE    //日期切换
};

typedef void(^AttendanceSignActionBlock)(AttendanceSignActionType type);

@interface AttendanceSignView : UITableView

- (void)setQueryTime:(NSNumber *) queryTime;
- (void)setEmployeeType:(NSInteger) employeeType;

//@property (nonatomic, strong) AttendanceSettingDetail *settingDetail;
@property (nonatomic, strong) NSMutableDictionary *signReachable;
@property (nonatomic, strong) NSMutableArray *dateArray;

@property (nonatomic, copy) AttendanceSignActionBlock actionBlock;
@end
