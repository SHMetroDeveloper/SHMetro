//
//  WorkOrderTodayEntity.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/5/5.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkOrderChartEntity.h"
#import "WorkOrderServerConfig.h"
#import "SystemConfig.h"
#import "MJExtension.h"


/**
 *
 *  今日工单概况
 *
 */
@implementation WorkOrderChartTodayParam
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress], WORK_ORDER_CHART_TODAY];
    return res;
}
@end

@implementation WorkOrderChartToday
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end

@implementation WorkOrderChartTodayResponse
- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"WorkOrderChartToday"
             };
}
@end





/**
 *
 *  近七日工单完成情况
 *
 */
@implementation WorkOrderChartCurrentDaysParam
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],WORK_ORDER_CHART_CURRENT];
    return res;
}
@end


@implementation WorkOrderChartCurrentDays
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end

@implementation WorkOrderChartCurrentDaysResponse
- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"WorkOrderChartCurrentDays"
             };
}
@end




/**
 *
 *  工单总数
 *
 */
@implementation WorkOrderChartStatisticsParam
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],WORK_ORDER_CHART_STATISTICS];
    return res;
}
@end


@implementation WorkOrderChartStatistics
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end


@implementation WorkOrderChartStatisticsResponse
- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"WorkOrderChartStatistics"
             };
}
@end





/**
 *
 *  每月工单数
 *
 */
@implementation WorkOrderChartMonthlyParam
- (instancetype)init {
    self = [super init];
    if (self) {
        _month = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],WORK_ORDER_CHART_MONTHLY];
    return res;
}
@end

@implementation WorkOrderChartMonthly
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end

@implementation WorkOrderChartMonthlyResponse
- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"WorkOrderChartMonthly"
             };
}
@end





















