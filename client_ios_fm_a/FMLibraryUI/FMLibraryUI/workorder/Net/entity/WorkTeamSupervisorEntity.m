//
//  WorkTeamSupervisorEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/6/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "WorkTeamSupervisorEntity.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"
#import "MJExtension.h"

@implementation WorkTeamSupervisorEntity

@end

@implementation WorkTeamSupervisorRequestParam
- (instancetype) init {
    self = [super init];
    return self;
}
- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], WORK_ORDER_LABORER_WORK_TEAM_SUPERVISOR_URL];
    return res;
}
@end

@implementation WorkTeamSupervisorRequestResponse
+ (NSDictionary *) mj_objectClassInArray {
    return @{
             @"data" : @"WorkTeamSupervisorEntity"
             };
}
@end
