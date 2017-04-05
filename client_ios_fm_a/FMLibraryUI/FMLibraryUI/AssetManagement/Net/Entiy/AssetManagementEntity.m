//
//  AssetManagementEntity.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/2.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "AssetManagementEntity.h"
#import "SystemConfig.h"
#import "AssetManagementConfig.h"
#import "MJExtension.h"
#import "FMUtils.h"

@implementation SearchCondition
@end

@implementation AssetManagementEquipmentsRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        _page = [[NetPageParam alloc] init];
        _searchCondition = [[SearchCondition alloc] init];
    }
    return self;
}

- (instancetype)initWithCondition:(SearchCondition *)searchCondition andPage:(NetPageParam *)page {
    self = [super init];
    if (self) {
        _page = [[NetPageParam alloc] init];
        _page.pageNumber = page.pageNumber;
        _page.pageSize = page.pageSize;
        _searchCondition = searchCondition;
    }
    return self;
}

- (NSString *)getUrl {
    NSString * url = [self wrapUrl:[NSString stringWithFormat:@"%@%@",[SystemConfig getServerAddress],ASSET_INFORMATION_URL]];
    return url;
}
@end


@implementation AssetManagementEquipmentsEntity
- (NSString *)getEquipmentNameDesc {
    NSString * name = nil;
    if ([FMUtils isStringEmpty:_code]) {
        name = [NSString stringWithFormat:@"%@",_name];
    } else {
        name = [NSString stringWithFormat:@"%@(%@)",_name,_code];
    }
    return name;
}

- (NSString *) getStatusStr {
    NSString * statusStr = nil;
    EquipmentStatus status = _status.integerValue;
    statusStr = [AssetManagementConfig getEquipmentStatusStrByStatus:status];
    return statusStr;
}

- (UIColor *) getStatusColor {
    UIColor * statusColor = nil;
    EquipmentStatus status = _status.integerValue;
    statusColor = [AssetManagementConfig getEquipmentStatusColorByStatus:status];
    return statusColor;
}

@end


@implementation AssetManagementEquipmentsResponseData
+ (NSDictionary *) mj_objectClassInArray {
    return @{
             @"contents" : @"AssetManagementEquipmentsEntity"
             };
}
@end



@implementation AssetManagementEquipmentsResponse
- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [[AssetManagementEquipmentsResponseData alloc] init];
    }
    return self;
}

@end













