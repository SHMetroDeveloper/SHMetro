//
//  OperateReservationEntity.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "OperateReservationEntity.h"
#import "SystemConfig.h"
#import "InventoryServerConfig.h"


@implementation ReservationApprovalRequestParam
- (instancetype) init {
    self = [super init];
    return self;
}

- (NSString *) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], RESERVATION_APPROVAL_URL];
    return res;
}
@end
