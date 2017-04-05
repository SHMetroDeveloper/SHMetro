//
//  InventoryWarehouseQueryEntity.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/5.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryWarehouseQueryEntity.h"
#import "SystemConfig.h"
#import "InventoryServerConfig.h"
#import "MJExtension.h"


@implementation InventoryWarehouseQueryRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        _page = [[NetPageParam alloc] init];
    }
    return self;
}

- (instancetype)initWithPageNumber:(NSNumber *)pageNumber andPageSize:(NSNumber *)pageSize {
    self = [super init];
    if (self) {
        _page = [[NetPageParam alloc] init];
        _page.pageNumber = pageNumber;
        _page.pageSize = pageSize;
    }
    return self;
}

- (NSString *)getUrl {
    NSString *res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],INVENTORY_WAREHOUSE_QUERY_URL];
    return res;
}
@end


@implementation InventoryWarehouseDetail

@end


@implementation InventoryWarehouseQueryResponseData
+ (NSDictionary *) mj_objectClassInArray {
    return @{
             @"contents" : @"InventoryWarehouseDetail"
             };
}
@end


@implementation InventoryWarehouseQueryResponse

@end


