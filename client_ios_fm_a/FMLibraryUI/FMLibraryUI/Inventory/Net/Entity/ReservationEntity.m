//
//  ReservationEntity.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "ReservationEntity.h"
#import "SystemConfig.h"
#import "InventoryServerConfig.h"

@implementation ReservationEntity

@end


@implementation GetReservationListParam

- (instancetype) initWithUserId:(NSNumber *) userId queryType:(ReservationQueryType) queryType page:(NetPage *) page {
    self = [super init];
    if(self) {
        _userId = userId;
        _queryType = queryType;
        _page = [[NetPageParam alloc] init];
        _page.pageNumber = page.pageNumber;
        _page.pageSize = page.pageSize;
    }
    return self;
}
- (instancetype) initWithUserId:(NSNumber *) userId queryType:(ReservationQueryType) queryType page:(NetPage *) page timeStart:(NSNumber *) timeStart timeEnd:(NSNumber *) timeEnd {
    self = [super init];
    if(self) {
        _userId = userId;
        _queryType = queryType;
        _page = [[NetPageParam alloc] init];
        _page.pageNumber = page.pageNumber;
        _page.pageSize = page.pageSize;
        _timeStart = [timeStart copy];
        _timeEnd = [timeEnd copy];
    }
    return self;
}

- (NSString *) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], GET_RESERVATION_LIST_URL];
    return res;
}

@end

@implementation GetReservationListOfWorkOrderParam
- (instancetype) init {
    self = [super init];
    return self;
}

- (NSString *) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], GET_RESERVATION_LIST_OF_WORK_ORDER_URL];
    return res;
}

@end

@implementation GetReservationListResponseData
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"contents" : @"ReservationEntity"
             };
}
@end

@implementation GetReservationListResponse
@end

@implementation GetReservationListOfWorkOrderResponse
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"data" : @"ReservationEntity"
             };
}
@end
