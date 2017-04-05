//
//  InventoryMaterialCheckEntity.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/8.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryMaterialCheckEntity.h"
#import "SystemConfig.h"
#import "InventoryServerConfig.h"

@implementation InventoryMaterialCheckBatch

@end

@implementation InventoryMaterialCheckInventory
- (instancetype)init {
    self = [super init];
    if (self) {
        _batch = [NSMutableArray new];
    }
    return self;
}
@end

@implementation InventoryMaterialCheckRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        _inventory = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)getUrl {
    NSString *res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],INVENTORY_MATERIAL_CHECK_URL];
    return res;
}

@end
