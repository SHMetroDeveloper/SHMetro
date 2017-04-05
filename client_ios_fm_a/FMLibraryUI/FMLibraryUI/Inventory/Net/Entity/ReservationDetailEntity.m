//
//  ReservationDetailEntity.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "ReservationDetailEntity.h"
#import "SystemConfig.h"
#import "InventoryServerConfig.h"

@implementation ReservationMaterial
@end

@implementation ReservationDetailEntity

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"materials" : @"ReservationMaterial"
             };
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _materials = [[NSMutableArray alloc] init];
    }
    return self;
}
@end


@implementation GetReservationDetailRequestParam

- (instancetype) initWith:(NSNumber *)requestId {
    self = [super init];
    if(self) {
        _requestId = requestId;
    }
    return self;
}

- (NSString *) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], GET_RESERVATION_DETAIL_URL];
    return res;
}

@end

@implementation GetReservationDetailResponse
@end
