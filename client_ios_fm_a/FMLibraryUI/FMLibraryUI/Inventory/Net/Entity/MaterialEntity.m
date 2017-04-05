//
//  MaterialEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "MaterialEntity.h"
#import "SystemConfig.h"
#import "InventoryServerConfig.h"

@implementation MaterialEntity
- (instancetype)init {
    self = [super init];
    if (self) {
        _pictures = [NSMutableArray new];
    }
    return self;
}
@end


@implementation InventoryGetMaterialCondition
@end


@implementation InventoryGetMaterialParam
- (instancetype) initWith:(NetPageParam *) page warehouse:(NSNumber *) warehouseId{
    self = [super init];
    if(self) {
        _page = [[NetPageParam alloc] init];
        _page.pageNumber = [page.pageNumber copy];
        _page.pageSize = [page.pageSize copy];
        
        _warehouseId = [warehouseId copy];
        
    }
    return self;
}
- (instancetype) initWith:(NetPageParam *) page warehouse:(NSNumber *) warehouseId condition:(InventoryGetMaterialCondition *) condition {
    self = [super init];
    if(self) {
        _page = [[NetPageParam alloc] init];
        _page.pageNumber = [page.pageNumber copy];
        _page.pageSize = [page.pageSize copy];
        
        _warehouseId = [warehouseId copy];
        _condition = condition;
    }
    return self;
}

- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], GET_MATERIAL_LIST_URL];
    return res;
}
@end


@implementation InventoryGetMaterialResponseData
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"MaterialEntity"
             };
}
@end

@implementation InventoryGetMaterialResponse

@end
