//
//  InventoryMaterialStorageInEntity.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/28.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryMaterialStorageInEntity.h"
#import "SystemConfig.h"
#import "InventoryServerConfig.h"
#import "MJExtension.h"


@implementation InventoryMaterialStorageInBatch

@end


@implementation InventoryMaterialStorageInInventory
- (instancetype)init {
    self = [super init];
    if (self) {
        _batch = [NSMutableArray new];
    }
    return self;
}
@end


@implementation InventoryMaterialStorageInRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        _inventory = [NSMutableArray new];
    }
    return self;
}

- (NSString *)getUrl {
    NSString *res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],INVENTORY_MATERIAL_STORAGE_IN_URL];
    return res;
}
@end


@implementation InventoryMaterialStorageInResponse

@end
