//
//  EditReservationHandlerEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/18/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "EditReservationHandlerEntity.h"
#import "SystemConfig.h"
#import "InventoryServerConfig.h"

@implementation EditReservationHandlerParam
- (instancetype) init {
    self = [super init];
    return self;
}

- (NSString *) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], INVENTORY_RESERVATION_HANDLER_EDIT];
    return res;
}
@end
