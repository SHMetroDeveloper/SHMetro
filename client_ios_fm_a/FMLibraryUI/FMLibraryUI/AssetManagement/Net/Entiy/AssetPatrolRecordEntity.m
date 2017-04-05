//
//  AssetPatrolRecordEntity.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/7.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "AssetPatrolRecordEntity.h"
#import "SystemConfig.h"
#import "AssetManagementConfig.h"
#import "MJExtension.h"


@implementation AssetPatrolRecordRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        _page = [[NetPageParam alloc] init];
    }
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],ASSET_CORE_COMPONENT_PATROL_RECORD_URL];
    return res;
}
@end

@implementation AssetPatrolRecordEntity

@end

@implementation AssetPatrolRecordResponseData
- (instancetype)init {
    self = [super init];
    if (self) {
        _contents = [NSMutableArray new];
        _page = [[NetPage alloc] init];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"AssetPatrolRecordEntity"
             };
}
@end

@implementation AssetPatrolRecordResponse

@end
