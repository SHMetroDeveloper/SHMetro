//
//  AssetBaseInfoEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/11/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "AssetBaseInfoEntity.h"
#import "SystemConfig.h"
#import "AssetManagementConfig.h"

@implementation AssetEquipmentCount

@end

@implementation AssetBaseInfoEntity

@end

@implementation RequestAssetBaseInfoParam
- (instancetype) init {
    self = [super init];
    return self;
}

- (NSString *)getUrl {
    NSString * url = [self wrapUrl:[NSString stringWithFormat:@"%@%@",[SystemConfig getServerAddress],ASSET_BASE_INFO_URL]];
    return url;
}
@end

@implementation AssetBaseInfoResponse


@end