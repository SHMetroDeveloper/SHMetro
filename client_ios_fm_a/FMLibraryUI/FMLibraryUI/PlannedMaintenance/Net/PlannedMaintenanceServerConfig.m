//
//  PlannedMaintenanceServerConfig.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/27.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "PlannedMaintenanceServerConfig.h"

#import "FMTheme.h"
#import "BaseBundle.h"

//获取维护日历
NSString * const PLANNED_MAINTENANCE_GET_CALENDAR = @"/m/v1/preventive/todos/query";

//获取维护详情
NSString * const PLANNED_MAINTENANCE_GET_DETAIL = @"/m/v2/preventive/info";



@interface PlannedMaintenanceServerConfig ()

@end

@implementation PlannedMaintenanceServerConfig

//获取状态
+ (NSString *) getMaintenanceStatsDesc:(MaintenanceTaskStatus) status {
    NSString * res = @"";
    switch(status){
        case PM_TASK_STATUS_UNDO:
            res = [[BaseBundle getInstance] getStringByKey:@"ppm_status_undo" inTable:nil];
            break;
        case PM_TASK_STATUS_PROCESS:
            res = [[BaseBundle getInstance] getStringByKey:@"ppm_status_process" inTable:nil];
            break;
        case PM_TASK_STATUS_FINISHED:
            res = [[BaseBundle getInstance] getStringByKey:@"ppm_status_finished" inTable:nil];
            break;
        case PM_TASK_STATUS_LEAK:
            res = [[BaseBundle getInstance] getStringByKey:@"ppm_status_missed" inTable:nil];
            break;
        default:
            break;
    }
    return res;
}

+ (UIColor *) getMaintenanceStatsColor:(MaintenanceTaskStatus)status {
    UIColor * color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    switch(status){
        case PM_TASK_STATUS_UNDO:
            color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
            break;
        case PM_TASK_STATUS_PROCESS:
            color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
            break;
        case PM_TASK_STATUS_FINISHED:
            color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
            break;
        case PM_TASK_STATUS_LEAK:
            color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
            break;
        default:
            break;
    }
    return color;
}
@end
