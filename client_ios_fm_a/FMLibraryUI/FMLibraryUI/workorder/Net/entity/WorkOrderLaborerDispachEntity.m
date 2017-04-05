//
//  WorkOrderLaborerEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/23.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  工单执行人

#import "WorkOrderLaborerDispachEntity.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"

@implementation WorkOrderLaborerDispachRequestParam
- (instancetype) initWithUserId:(NSNumber *) userId andOrderId:(NSNumber *)woId{
    self = [super init];
    if(self) {
        _userId = userId;
        _woId = woId;
    }
    return self;
}
- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], GET_WORK_ORDER_DISPACH_LABORER_LIST_URL];
    return res;
}
@end


@implementation WorkOrderLaborerDispach
@end

@implementation WorkOrderLaborerGroupDispach

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"members" : @"WorkOrderLaborerDispach"
             };
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _members = [[NSMutableArray alloc] init];
    }
    return self;
}
@end

@implementation WorkOrderLaborerResponse

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"WorkOrderLaborerGroupDispach"
             };
}


@end
