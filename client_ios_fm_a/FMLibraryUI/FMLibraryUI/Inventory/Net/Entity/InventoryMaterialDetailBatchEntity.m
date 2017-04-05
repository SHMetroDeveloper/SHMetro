//
//  InventoryMaterialDetailBatchEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/29/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "InventoryMaterialDetailBatchEntity.h"
#import "SystemConfig.h"
#import "InventoryServerConfig.h"
#import "MJExtension.h"


@implementation InventoryMaterialDetailBatchEntity

@end


@implementation InventoryGetMaterialDetailBatchParam
- (instancetype) init {
    self = [super init];
    if(self) {
        _page = [[NetPageParam alloc] init];
    }
    return self;
}
- (NSString *) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], INVENTORY_MATERIAL_BATCH_URL];
    return res;
}
@end

@implementation InventoryGetMaterialDetailBatchResponseData
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"InventoryMaterialDetailBatchEntity"
             };
}
@end

@implementation InventoryGetMaterialDetailBatchResponse
@end
