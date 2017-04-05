//
//  AssetCoreComponentListEntity.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/7.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "AssetCoreComponentListEntity.h"
#import "SystemConfig.h"
#import "AssetManagementConfig.h"
#import "MJExtension.h"

@implementation AssetCoreComponentListParam
- (instancetype)init {
    self = [super init];
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],ASSET_CORE_COMPONENT_LIST_URL];
    return res;
}
@end

@implementation AssetCoreComponentListEntity

@end

@implementation AssetCoreComponentListResponse
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"AssetCoreComponentListEntity",
             };
}
@end

