//
//  MissionListEntity.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/27.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "EnergyTaskListEntity.h"
#import "SystemConfig.h"
#import "FMUtils.h"
#import "EnergyServerConfig.h"

@implementation EnergyTaskListRequestParam

- (instancetype) initWithpreRequestDate:(NSNumber *)preRequestDate page:(NetPageParam *) page {
    self = [super init];
    if (self) {
        _preRequestDate = preRequestDate;
        _page = [[NetPageParam alloc] init];
        if(page) {
            _page.pageNumber = page.pageNumber;
            _page.pageSize = page.pageSize;
        }
    }
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],GET_METER_MISSION_LIST_URL];
    return res;
}

@end

@implementation EnergyTaskEntity

+ (NSDictionary *) mj_objectClassInArray {
    return @{
             @"meters" : @"EnergyTaskDetailEntity"
             };
}

- (instancetype)init {
    self = [super init];
    return self;
}

@end

@implementation EnergyTaskDetailEntity
@end

@implementation EnergyTaskListResponseData
+ (NSDictionary *) mj_objectClassInArray {
    return @{
             @"contents" : @"EnergyTaskEntity"
             };
}
@end

@implementation EnergyTaskListResponse

@end



