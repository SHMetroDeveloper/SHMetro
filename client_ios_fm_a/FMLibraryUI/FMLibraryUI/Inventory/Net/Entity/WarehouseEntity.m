//
//  WarehouseEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "WarehouseEntity.h"
#import "SystemConfig.h"
#import "InventoryServerConfig.h"
#import "MJExtension.h"

@implementation WarehouseAdministrator
@end

@implementation WarehouseEntity
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"administrator" : @"WarehouseAdministrator"
             };
}
@end


@implementation InventoryGetWarehouseParam
- (instancetype) initWith:(NetPageParam *) page employeeId:(NSNumber *) emId{
    self = [super init];
    if(self) {
        _page = [[NetPageParam alloc] init];
        _page.pageNumber = [page.pageNumber copy];
        _page.pageSize = [page.pageSize copy];
        _employeeId = [emId copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], GET_WAREHOUSE_LIST_URL];
    return res;
}
@end

@implementation InventoryGetWarehouseResponseData
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"WarehouseEntity"
             };
}
@end

@implementation InventoryGetWarehouseResponse
@end
