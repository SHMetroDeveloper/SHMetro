//
//  InventoryMaterialDetailRecordEntity.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/28.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryMaterialDetailRecordEntity.h"
#import "SystemConfig.h"
#import "InventoryServerConfig.h"
#import "MJExtension.h"

@implementation InventoryMaterialDetailRecordRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        _page = [[NetPageParam alloc] init];
    }
    return self;
}

- (NSString *)getUrl {
    NSString *res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],INVENTORY_MATERIAL_DETAIL_RECORD_URL];
    return res;
}
@end

@implementation InventoryMaterialDetailRecordDetail

@end

@implementation InventoryMaterialDetailRecordResponseData
- (instancetype)init {
    self = [super init];
    if (self) {
        _contents = [NSMutableArray new];
    }
    return self;
}

+ (NSDictionary *) mj_objectClassInArray {
    return @{
             @"contents" : @"InventoryMaterialDetailRecordDetail"
             };
}
@end

@implementation InventoryMaterialDetailRecordResponse

@end
