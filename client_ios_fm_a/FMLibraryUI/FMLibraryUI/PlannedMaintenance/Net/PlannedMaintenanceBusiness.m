//
//  PlannedMaintenanceBusiness.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/27.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "PlannedMaintenanceBusiness.h"
#import "PlannedMaintenanceServerConfig.h"
#import "PlannedMaintenanceNetRequest.h"
#import "MaintenanceEntity.h"
#import "MaintenanceDetailEntity.h"
#import "MJExtension.h"




PlannedMaintenanceBusiness * pmBusinessInstance;

@interface PlannedMaintenanceBusiness ()

@property (readwrite, nonatomic, strong) PlannedMaintenanceNetRequest * netRequest;

@end

@implementation PlannedMaintenanceBusiness

+ (instancetype) getInstance {
    if(!pmBusinessInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            pmBusinessInstance = [[PlannedMaintenanceBusiness alloc] init];
        });
    }
    return pmBusinessInstance;
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _netRequest = [PlannedMaintenanceNetRequest getInstance];
    }
    return self;
}

//获取维护日历
- (void) getMaintenanceCalendarStart:(NSNumber *) timeStart end:(NSNumber *) timeEnd Success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        MaintenanceCalendarRequestParam * param = [[MaintenanceCalendarRequestParam alloc] initWithConditionStartTime:timeStart endTime:timeEnd];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            MaintenanceCalendarResponse * response = [MaintenanceCalendarResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_PM_GET_CALENDAR, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_PM_GET_CALENDAR, error);
            }
        }];
    }
}


//请求计划性维护详情
- (void) getMaintenanceDetailWithPmId:(NSNumber *) pmId todoId:(NSNumber *) todoId success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        MaintenanceDetailRequestParam * param = [[MaintenanceDetailRequestParam alloc] initWithPmId:pmId todoId:todoId];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            MaintenanceDetailResponse * response = [MaintenanceDetailResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_WO_GET_DETAIL, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_GET_DETAIL, error);
            }
        }];
    }
}

@end
