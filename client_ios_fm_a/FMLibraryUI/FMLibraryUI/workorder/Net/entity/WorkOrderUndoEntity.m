//
//  UndoWorkJobNumberEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  待处理工单


#import "WorkOrderUndoEntity.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"
#import "FMUtils.h"
#import "MJExtension.h"

@implementation UndoWorkOrderRequestParam

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
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], GET_JOB_URL];
    return res;
}

@end


@implementation WorkOrderUndo

- (instancetype) init {
    self = [super init];
    return self;
}

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
    WorkOrderPriorityLevel level = (WorkOrderPriorityLevel)_priorityId;
    res = [WorkOrderServerConfig getOrderPriorityLevelDesc:level];
    return res;
}

@end



@implementation UndoWorkOrderResponseData

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"WorkOrderUndo"
             };
}

@end


@implementation UndoWorkOrderResponse

- (instancetype) init {
    self = [super init];
    if(self) {
        self.data = [[UndoWorkOrderResponseData alloc] init];
    }
    return self;
}

@end



