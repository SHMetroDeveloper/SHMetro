//
//  InventoryMaterialDetailEntity.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/28.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryMaterialDetailEntity.h"
#import "SystemConfig.h"
#import "InventoryServerConfig.h"
#import "MJExtension.h"





@implementation InventoryMaterialDetailAttachment
@end


@implementation InventoryMaterialDetail
+ (NSDictionary *) mj_objectClassInArray {
    return @{@"attachment" : @"InventoryMaterialDetailAttachment"
             };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (!_pictures) {
            _pictures = [NSMutableArray new];
        }
        if (!_attachment) {
            _attachment = [NSMutableArray new];
        }
    }
    return self;
}

@end

@implementation InventoryMaterialDetailIdRequestParam
- (NSString *) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], INVENTORY_MATERIAL_DETAIL_URL];
    return res;
}
@end

@implementation InventoryMaterialDetailCodeRequestParam
- (NSString *) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], INVENTORY_MATERIAL_DETAIL_CODE_URL];
    return res;
}
@end

@implementation InventoryMaterialDetailResponse
- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [[InventoryMaterialDetail alloc] init];
    }
    return self;
}
@end
