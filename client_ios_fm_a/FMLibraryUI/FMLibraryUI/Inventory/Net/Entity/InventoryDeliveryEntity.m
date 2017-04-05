//
//  InventoryDeliveryEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "InventoryDeliveryEntity.h"
#import "SystemConfig.h"
#import "InventoryServerConfig.h"

@implementation InventoryDeliveryMaterialBatchEntity
- (instancetype) copy {
    InventoryDeliveryMaterialBatchEntity * batch = [[InventoryDeliveryMaterialBatchEntity alloc] init];
    batch.amount = _amount;
    batch.batchId = [_batchId copy];
    return batch;
}
@end

@implementation InventoryDeliveryMaterialEntity
- (instancetype) init {
    self = [super init];
    if(self) {
        _batch = [[NSMutableArray alloc] init];
    }
    return self;
}
@end

@implementation InventoryDeliveryParam
- (instancetype) init {
    self = [super init];
    if(self) {
        _inventory = [[NSMutableArray alloc] init];
    }
    return self;
}
- (NSString *) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], INVENTORY_DELIVERY_URL];
    return res;
}
@end
