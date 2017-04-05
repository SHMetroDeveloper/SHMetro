//
//  PlannedMaintenanceBusiness.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/27.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseBusiness.h"
#import "MaintenanceEntity.h"


typedef NS_ENUM(NSInteger, PlannedMaintenanceBusinessType) {
    BUSINESS_PM_UNKNOW,   //
    BUSINESS_PM_GET_CALENDAR,   //获取维护日历
    BUSINESS_WO_GET_DETAIL,    //获取维护详情
    
};

@interface PlannedMaintenanceBusiness : BaseBusiness

//获取工单业务的实例对象
+ (instancetype) getInstance;

//获取维护日历
- (void) getMaintenanceCalendarStart:(NSNumber *) timeStart end:(NSNumber *) timeEnd Success:(business_success_block) success fail:(business_failure_block) fail;

//请求计划性维护详情
- (void) getMaintenanceDetailWithPmId:(NSNumber *) pmId todoId:(NSNumber *) todoId success:(business_success_block) success fail:(business_failure_block) fail;

@end