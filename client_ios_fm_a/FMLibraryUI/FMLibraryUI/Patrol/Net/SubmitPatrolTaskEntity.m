//
//  SubmitPatrolTaskEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/15.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "SubmitPatrolTaskEntity.h"
#import "SystemConfig.h"
#import "PatrolServerConfig.h"

@implementation SubmitPatrolSpotResult

@end

@implementation SubmitPatrolExceptionEquipment
@end

@implementation SubmitPatrolSpot
- (instancetype) init {
    self = [super init];
    if(self) {
        _contents = [[NSMutableArray alloc] init];
        _exceptionEquipment = [[NSMutableArray alloc] init];
    }
    return self;
}
@end

@implementation SubmitPatrolTask
- (instancetype) init {
    self = [super init];
    if(self) {
        _spots = [[NSMutableArray alloc] init];
    }
    return self;
}
@end

@implementation SubmitPatrolTaskRequest

- (instancetype) initWithType:(PatrolSubmitOperateType) operateType patrolTasks:(NSMutableArray *) taskArray userId:(NSNumber *)userId{
    self = [super init];
    if(self) {
        _operateType = operateType;
        _patrolTask = taskArray;
        _userId = userId;
    }
    return self;
}
-(NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], PATROL_SUBMIT_PATROL_TASK_URL];
    return res;
}

@end
