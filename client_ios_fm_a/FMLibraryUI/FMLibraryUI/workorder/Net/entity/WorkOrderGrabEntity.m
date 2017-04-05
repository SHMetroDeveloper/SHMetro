//
//  WorkOrderGrabEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/3.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "WorkOrderGrabEntity.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"
#import "FMUtils.h"

@implementation GrabWorkOrderRequestParam

- (instancetype) initWithPage:(NetPageParam *) page {
    self = [super init];
    if(self) {
        _page = [[NetPageParam alloc] init];
        _page.pageNumber = [page.pageNumber copy];
        _page.pageSize = [page.pageSize copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], GET_JOB_GRAB_URL];
    return res;
}


@end

@implementation WorkOrderGrab


//创建时间
- (NSString *) getCreateDateStr {
    NSString * res = @"";
    if(![FMUtils isObjectNull:_createDateTime] && ![_createDateTime isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        NSDate * date = [FMUtils timeLongToDate:_createDateTime];
        res = [FMUtils getMinuteStrWithoutYear:date];
    }
    return res;
}
//优先级
- (NSString *) getPriorityName {
    NSString * res = @"";
    WorkOrderPriorityLevel level = (WorkOrderPriorityLevel)_priority;
    res = [WorkOrderServerConfig getOrderPriorityLevelDesc:level];
    return res;
}

//是否可抢
- (BOOL) isGrabAble {
    BOOL res = NO;
    if(_grabType == WORK_ORDER_GRAB_TYPE_GRAB && _status == ORDER_STATUS_CREATE && (_grabStatus == WORK_ORDER_GRAB_LABORER_STATUS_UNTOOK || _grabStatus == WORK_ORDER_GRAB_LABORER_STATUS_UNKNOW)) {
        res = YES;
    }
    return res;
}
@end
