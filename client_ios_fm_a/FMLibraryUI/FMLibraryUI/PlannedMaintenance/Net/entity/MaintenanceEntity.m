//
//  MaintenanceEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/27.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "MaintenanceEntity.h"
#import "SystemConfig.h"
#import "PlannedMaintenanceServerConfig.h"
#import "FMUtils.h"

@implementation MaintenanceCalendarRequestParam
- (instancetype)initWithConditionStartTime:(NSNumber *)startTime endTime:(NSNumber *)endTime {
    self = [super init];
    if(self) {
        _startTime = [startTime copy];
        _endTime = [endTime copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], PLANNED_MAINTENANCE_GET_CALENDAR];
    return res;
}
@end

@implementation MaintenanceEntity
- (instancetype) init {
    self = [super init];
    return self;
}

//开始时间
- (NSString *) getStartDateStr {
    NSString * res = @"";
    NSDate * date = [FMUtils timeLongToDate:_dateTodo];
    res = [FMUtils getDayStr:date];
    return res;
}
//获取状态描述
- (NSString *) getStatusDesc {
    NSString * res = [PlannedMaintenanceServerConfig getMaintenanceStatsDesc:_status];
    return res;
}
@end

@implementation MaintenanceCalendarResponse
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"MaintenanceEntity"
             };
}
@end
