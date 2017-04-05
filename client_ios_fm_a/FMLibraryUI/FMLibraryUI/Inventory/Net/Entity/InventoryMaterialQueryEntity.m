//
//  InventoryMaterialQueryEntity.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/28.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryMaterialQueryEntity.h"
#import "SystemConfig.h"
#import "InventoryServerConfig.h"
#import "MJExtension.h"

@implementation InventoryMaterialQueryCondition
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end

@implementation InventoryMaterialQueryRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        _page = [[NetPageParam alloc] init];
        _condition = [[InventoryMaterialQueryCondition alloc] init];
    }
    return self;
}

- (NSString *)getUrl {
    NSString *res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],GET_MATERIAL_LIST_URL];
    return res;
}
@end

@implementation InventoryMaterialQueryDetail
- (instancetype)init {
    self = [super init];
    if (self) {
        _pictures = [NSMutableArray new];
    }
    return self;
}
@end

@implementation InventoryMaterialQueryResponseData
+ (NSDictionary *) mj_objectClassInArray {
    return @{
             @"contents" : @"InventoryMaterialQueryDetail"
             };
}
@end

@implementation InventoryMaterialQueryResponse

@end

