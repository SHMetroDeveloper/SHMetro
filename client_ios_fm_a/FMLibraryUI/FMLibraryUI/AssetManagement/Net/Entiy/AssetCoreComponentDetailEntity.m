//
//  AssetCoreComponentDetailEntity.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/6.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "AssetCoreComponentDetailEntity.h"
#import "SystemConfig.h"
#import "AssetManagementConfig.h"
#import "MJExtension.h"

@implementation AssetCoreComponentDetailRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],ASSET_CORE_COMPONENT_DETAIL_URL];
    return res;
}
@end

@implementation AssetCoreComponentReplaceRecord

@end

@implementation AssetCoreComponentDetailEntity
- (instancetype)init {
    self = [super init];
    if (self) {
        _history = [NSMutableArray new];
    }
    return self;
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"history" : @"AssetCoreComponentReplaceRecord",
             };
}
@end


@implementation AssetCoreComponentDetailResponse
- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [[AssetCoreComponentDetailEntity alloc] init];
    }
    return self;
}
@end
