//
//  MaintenanceDetailEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "MaintenanceDetailEntity.h"
#import "SystemConfig.h"
#import "PlannedMaintenanceServerConfig.h"
#import "FMUtils.h"


@implementation MaintenanceDetailRequestParam
- (instancetype)initWithPmId:(NSNumber *) postId todoId:(NSNumber *)todoId {
    self = [super init];
    if(self) {
        _postId = [postId copy];
        _todoId = [todoId copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], PLANNED_MAINTENANCE_GET_DETAIL];
    return res;
}
@end

@implementation MaintenanceDetailStepEntity
@end

@implementation MaintenanceDetailMaterialEntity
@end


@implementation MaintenanceDetailToolEntity
@end

@implementation MaintenanceDetailEquipmentEntity
@end

@implementation MaintenanceDetailLocationEntity
@end

@implementation MaintenanceDetailOrderEntity
@end

@implementation MaintenanceDetailAttachmentEntity
@end


@implementation MaintenanceDetailEntity
- (instancetype)init {
    self = [super init];
    if (self) {
        _pmSteps = [[NSMutableArray alloc] init];
        _pmMaterials = [[NSMutableArray alloc] init];
        _pmTools = [[NSMutableArray alloc] init];
        _equipments = [[NSMutableArray alloc] init];
        _spaces = [[NSMutableArray alloc] init];
        _workOrders = [[NSMutableArray alloc] init];
        _pictures = [[NSMutableArray alloc] init];
//        _attachment = [[NSMutableArray alloc] init];
    }
    return self;
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"pmSteps" : @"MaintenanceDetailStepEntity",
             @"pmMaterials" : @"MaintenanceDetailMaterialEntity",
             @"pmTools" : @"MaintenanceDetailToolEntity",
             @"equipments" : @"MaintenanceDetailEquipmentEntity",
             @"spaces" : @"MaintenanceDetailLocationEntity",
             @"workOrders" : @"MaintenanceDetailOrderEntity",
             @"pictures" : @"MaintenanceDetailAttachmentEntity"
             };
}
@end

@implementation MaintenanceDetailResponse
@end
