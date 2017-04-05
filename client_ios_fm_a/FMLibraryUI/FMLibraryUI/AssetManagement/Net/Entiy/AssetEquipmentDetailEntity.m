//
//  AssetEquipmentDetailEntity.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/3.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "AssetEquipmentDetailEntity.h"
#import "SystemConfig.h"
#import "AssetManagementConfig.h"
#import "MJExtension.h"
#import "FMUtils.h"


@implementation AssetEquipmentDetailRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithEquipmentId:(NSNumber *)equipmentId {
    self = [super init];
    if (self) {
        _postId = [equipmentId copy];
    }
    return self;
}
- (NSString *)getUrl {
    NSString * url = [self wrapUrl:[NSString stringWithFormat:@"%@%@",[SystemConfig getServerAddress],ASSET_EQUIPMENT_DETAIL_URL]];
    return url;
}
@end


@implementation AssetEquipmentDetailQrcodeRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithUUID:(NSString *)uuid {
    self = [super init];
    if (self) {
        _uuid = [uuid copy];
    }
    return self;
}

- (NSString *)getUrl {
    NSString * url = [self wrapUrl:[NSString stringWithFormat:@"%@%@",[SystemConfig getServerAddress],ASSET_QRCODE_DETAIL_URL]];
    return url;
}
@end



@implementation AssetEquipmentManufacturer

@end



@implementation AssetEquipmentInstaller

@end



@implementation AssetEquipmentProvider

@end



@implementation AssetEquipmentParams

@end



@implementation AssetEquipmentServiceZone

@end


@implementation AssetEquipmentCWContract
- (instancetype)init {
    self = [super init];
    if (self) {
        _pictures = [NSMutableArray new];
    }
    return self;
}
@end


@implementation AssetEquipmentCMContract
- (instancetype)init {
    self = [super init];
    if (self) {
        _pictures = [NSMutableArray new];
    }
    return self;
}
@end


@implementation AssetEquipmentOtherContract
- (instancetype)init {
    self = [super init];
    if (self) {
        _pictures = [NSMutableArray new];
    }
    return self;
}
@end


@implementation AssetEquipmentOtherInfo
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end


@implementation AssetEquipmentDetailEntity
- (instancetype)init {
    self = [super init];
    if (self) {
//        _cwCntract = [NSMutableArray new];
        _cmContract = [NSMutableArray new];
        _otherContract = [NSMutableArray new];
        _pictureIds = [NSMutableArray new];
        _params = [NSMutableArray new];
        _serviceZones = [NSMutableArray new];
        _attachmentIds = [NSMutableArray new];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
//             @"cwCntract" : @"AssetEquipmentCWContract",
             @"cmContract" : @"AssetEquipmentCMContract",
             @"otherContract" : @"AssetEquipmentOtherContract",
             @"params" : @"AssetEquipmentParams",
             @"serviceZones" : @"AssetEquipmentServiceZone",
             };
}

@end



@implementation AssetEquipmentResponse

- (instancetype)init {
    self = [super init];
    if (self) {
        self.data = [[AssetEquipmentDetailEntity alloc] init];
    }
    return self;
}

@end




