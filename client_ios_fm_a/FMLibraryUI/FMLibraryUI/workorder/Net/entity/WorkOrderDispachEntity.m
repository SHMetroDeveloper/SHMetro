//
//  WorkOrderDispachEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/23.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WorkOrderDispachEntity.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"
#import "FMUtils.h"

@implementation WorkOrderDispachRequestParam

- (instancetype) initWithPage:(NetPageParam *) page {
    self = [super init];
    if(self) {
        if(!_page) {
            _page = [[NetPageParam alloc] init];
        }
        _page.pageNumber = [page.pageNumber copy];
        _page.pageSize = [page.pageSize copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], GET_WORK_ORDER_DISPACH_URL];
    return res;
}
@end


@implementation WorkOrderDispach

- (instancetype) init {
    self = [super init];
    if(self) {
    }
    return self;
}

//获取创建时间
- (NSString *) getCreateDateStr {
    NSString * res = @"";
    if(![FMUtils isObjectNull:_createDateTime] && ![_createDateTime isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        res = [FMUtils timeLongToDateString:_createDateTime];
    }
    return res;
}

- (NSString *) getStatusStr {
    NSString * res = @"";
    WorkOrderStatus status = (WorkOrderStatus)_status;
    res = [WorkOrderServerConfig getOrderStatusDesc:status];
    return res;
}

- (NSString *) getPriorityName {
    NSString * res = @"";
    WorkOrderPriorityLevel level = (WorkOrderPriorityLevel)_priorityId;
    res = [WorkOrderServerConfig getOrderPriorityLevelDesc:level];
    return res;
}
- (instancetype) copy {
    WorkOrderDispach * res = [[WorkOrderDispach alloc] init];
    res.woId = [_woId copy];
    res.code = [_code copy];
    res.pfmCode = [_pfmCode copy];
    res.priorityId = _priorityId;
    res.serviceTypeName = [_serviceTypeName copy];
    res.woDescription = [_woDescription copy];
    res.createDateTime = [_createDateTime copy];
    res.applicantName = [_applicantName copy];
    res.applicantPhone = [_applicantPhone copy];
    res.location = [_location copy];
    res.grabType = _grabType;
    res.status = _status;
    
    return res;
}
@end


@implementation DispachWorkOrderResponseData
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"contents" : @"WorkOrderDispach"
             };
}
@end

@implementation DispachWorkOrderResponse
@end






