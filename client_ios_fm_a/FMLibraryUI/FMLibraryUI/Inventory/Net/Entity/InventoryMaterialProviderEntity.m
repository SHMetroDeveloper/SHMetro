//
//  InventoryMaterialProviderEntity.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/28.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryMaterialProviderEntity.h"
#import "SystemConfig.h"
#import "InventoryServerConfig.h"
#import "MJExtension.h"

@implementation InventoryMaterialProviderRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        _page = [[NetPageParam alloc] init];
    }
    return self;
}

- (NSString *)getUrl {
    NSString *res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],INVENTORY_MATERIAL_PROVIDER_URL];
    return res;
}
@end


@implementation InventoryMaterialProviderDetail

@end


@implementation InventoryMaterialProviderResponseData
+ (NSDictionary *) mj_objectClassInArray {
    return @{
             @"contents" : @"InventoryMaterialProviderDetail"
             };
}
@end


@implementation InventoryMaterialProviderResponse

@end


