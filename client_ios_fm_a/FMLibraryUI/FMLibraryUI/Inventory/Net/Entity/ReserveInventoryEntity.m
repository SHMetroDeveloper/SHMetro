//
//  ReserveMaterialEntity.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "ReserveInventoryEntity.h"
#import "SystemConfig.h"
#import "InventoryServerConfig.h"

@implementation InventoryReserveEntity
@end


@implementation ReserveInventoryRequestParam

- (instancetype) init {
    self = [super init];
    if(self) {
        _materials = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], RESERVE_INVENTORY_URL];
    return res;
}

@end

@implementation ReserveInventoryResponse
@end