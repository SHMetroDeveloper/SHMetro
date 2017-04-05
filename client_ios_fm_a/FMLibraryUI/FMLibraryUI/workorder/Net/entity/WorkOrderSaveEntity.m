//
//  WorkOrderLaborerTimeEntity.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/5/3.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkOrderSaveEntity.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"
#import "MJExtension.h"

@implementation WorkOrderLaborerTimeSaveRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],WORK_ORDER_LABORER_TIME_SAVE_URL];
    return res;
}
@end


@implementation WorkOrderToolSaveRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],WORK_ORDER_TOOL_SAVE_URL];
    return res;
}
@end

@implementation WorkOrderToolIDResponse
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end




@implementation WorkOrderChargeSaveRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],WORK_ORDER_CHARGE_SAVE_URL];
    return res;
}
@end

@implementation WokrOrderChargeResponse
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end

@implementation WorkOrderEquipmentOperationRecord
@end

@implementation WorkOrderEquipmentEditRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        _operation = [NSMutableArray new];
    }
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],WORK_ORDER_EQUIPMENT_EDIT_URL];
    return res;
}
@end

@implementation WorkOrderWorkContentSaveRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        _pictures = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],WORK_ORDER_WORKCONTENT_SAVE_URL];
    return res;
}
@end


@implementation WorkOrderPlanMaintanceStepRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],WORK_ORDER_PLAN_MAINTENANCE_STEP_URL];
    return res;
}
@end


@implementation WorkOrderLaborerWorkTeamRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],WORK_ORDER_LABORER_WORK_TEAM_URL];
    return res;
}
@end

@implementation WorkOrderLaborerWorkTeam
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end

@implementation WorkOrderLaborerWorkTeamResponse
- (instancetype)init{
    self = [super init];
    if (self) {
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"WorkOrderLaborerWorkTeam"
             };
}
@end


@implementation WorkOrderSaveFailureReasonParam
- (instancetype)init {
    self = [super init];
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],WORK_ORDER_FAILURE_REASON_SAVE_URL];
    return res;
}
@end









