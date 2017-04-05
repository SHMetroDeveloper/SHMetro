//
//  AssetWorkOrderRecordEntity.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/7.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "AssetWorkOrderRecordEntity.h"
#import "SystemConfig.h"
#import "AssetManagementConfig.h"
#import "MJExtension.h"
#import "FMUtils.h"

@implementation AssetWorkOrderQueryRequestParam

- (instancetype)init {
    self = [super init];
    if (self) {
        _page = [[NetPageParam alloc] init];
    }
    return self;
}

- (instancetype)initWithQueryParams:(NSNumber *) eqId
                               page:(NetPageParam *) page
                         isLaborers:(BOOL) isLaborers
                               type:(AssetRecordQueryType) type {
    self = [super init];
    if (self) {
        _page = [[NetPageParam alloc]init];
        _page.pageNumber = page.pageNumber;
        _page.pageSize = page.pageSize;
        _eqId = eqId;
        _isLaborers = isLaborers;
        _type = type;
    }
    return self;
}

- (NSString *)getUrl {
    NSString * url = [self wrapUrl:[NSString stringWithFormat:@"%@%@",[SystemConfig getServerAddress],ASSET_WORK_ORDER_QUERY_URL]];
    return url;
}

@end


@implementation AssetWorkOrderFixedEntity

@end


@implementation AssetWorkOrderMaintainEntity

@end



//维修记录
@implementation AssetFixedRecordResponseData
+ (NSDictionary *) mj_objectClassInArray {
    return @{
             @"contents" : @"AssetWorkOrderFixedEntity"
             };
}
@end

@implementation AssetFixedRecordResponse
- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [[AssetFixedRecordResponseData alloc] init];
    }
    return self;
}
@end


//维保记录
@implementation AssetMaintainRecordResponseData
+ (NSDictionary *) mj_objectClassInArray {
    return @{
             @"contents" : @"AssetWorkOrderMaintainEntity"
             };
}
@end

@implementation AssetMaintainRecordResponse
- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [[AssetMaintainRecordResponseData alloc] init];
    }
    return self;
}
@end










