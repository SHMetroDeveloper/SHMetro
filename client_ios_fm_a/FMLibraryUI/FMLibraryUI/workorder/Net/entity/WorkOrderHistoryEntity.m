//
//  WorkOrderHistoryEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/23.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  历史工单

#import "WorkOrderHistoryEntity.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"
#import "FMUtils.h"


@implementation WorkOrderHistorySearchCondition
- (instancetype) init {
    self = [super init];
    if(self) {
        _priority = [[NSMutableArray alloc] init];
        _status = [[NSMutableArray alloc] init];
    }
    return self;
}
@end

@implementation WorkOrderHistoryRequestParam
- (instancetype) initWithSearchCondition:(WorkOrderHistorySearchCondition *) condition andPage:(NetPageParam *) page {
    self = [super init];
    if(self) {
        _searchCondition = condition;
        _page = [[NetPageParam alloc] init];
        _page.pageNumber = [page.pageNumber copy];
        _page.pageSize = [page.pageSize copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], GET_HISTORY_JOB_URL];
    return res;
}

@end


@implementation WorkOrderHistory

- (instancetype) init {
    self = [super init];
    if(self) {
    }
    return self;
}
- (NSString *) getCreateDateStr {
    NSString * res = @"";
    return res;
}
- (NSString *) getFinishTimeStr {
    NSString * res = @"";
    if(![FMUtils isObjectNull:_actualCompletionDateTime] && ![_actualCompletionDateTime isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        res = [FMUtils timeLongToDateStringWithOutYear:_actualCompletionDateTime];
    }
    return res;
}

- (NSString *) getCreateTimeStr {
    NSString * res = @"";
    if(![FMUtils isObjectNull:_createDateTime] && ![_createDateTime isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        res = [FMUtils timeLongToDateStringWithOutYear:_createDateTime];
    }
    return res;
}

- (NSString *) getStatusStr {
    NSString * res = @"";
    WorkOrderStatus status = (WorkOrderStatus) _status;
    res = [WorkOrderServerConfig getOrderStatusDesc:status];
    return res;
}

- (NSString *) getPriorityName {
    NSString * res = @"";
    WorkOrderPriorityLevel level = (WorkOrderPriorityLevel)_priorityId.integerValue;
    res = [WorkOrderServerConfig getOrderPriorityLevelDesc:level];
    return res;
}
- (NSString *) getReporter {
    return _applicantName;
}
- (NSString *) getPhone {
    return _applicantPhone;
}
@end


@implementation WorkOrderHistoryResponseData
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"WorkOrderHistory"
             };
}
@end

@implementation WorkOrderHistoryResponse
@end