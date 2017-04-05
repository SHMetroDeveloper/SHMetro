//
//  PlannedMaintenanceServerConfig.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/27.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MaintenanceTaskStatus) {
    PM_TASK_STATUS_UNKNOW,
    PM_TASK_STATUS_UNDO = 1,    //未处理
    PM_TASK_STATUS_PROCESS,     //处理中
    PM_TASK_STATUS_FINISHED,    //已完成
    PM_TASK_STATUS_LEAK,        //漏检
};

@interface PlannedMaintenanceServerConfig : NSObject

//获取状态描述
+ (NSString *) getMaintenanceStatsDesc:(MaintenanceTaskStatus) status;

//获取状态颜色
+ (UIColor *) getMaintenanceStatsColor:(MaintenanceTaskStatus)status;

@end


//获取维护日历
extern NSString * const PLANNED_MAINTENANCE_GET_CALENDAR;

//获取维护详情
extern NSString * const PLANNED_MAINTENANCE_GET_DETAIL;
