//
//  WorkOrderValidateEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/8.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkOrderUnValidatedEntity.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"
#import "FMUtils.h"

@implementation WorkOrderUnValidatedRequestParam

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
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], GET_WORK_ORDER_VALIDATE_URL];
    return res;
}

@end

@implementation WorkOrderUnValidatedEntity
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


@implementation WorkOrderUnValidatedResponseData
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"WorkOrderUnValidatedEntity"
             };
}
@end


@implementation WorkOrderUnValidatedResponse

- (instancetype) init {
    self = [super init];
    return self;
}
@end
