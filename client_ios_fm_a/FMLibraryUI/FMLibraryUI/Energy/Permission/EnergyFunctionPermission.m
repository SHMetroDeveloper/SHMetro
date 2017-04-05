//
//  EnergyFunctionPermission.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/3/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "EnergyFunctionPermission.h"
#import "PowerManager.h"


const NSString * ENERGY_FUNCTION = @"energy";

//const NSString * ENERGY_SUB_FUNCTION_TASK = @"task";


EnergyFunctionPermission * energyPermissionInstance;

@interface EnergyFunctionPermission ()

@end


@implementation EnergyFunctionPermission
+ (instancetype) getInstance {
    if(!energyPermissionInstance) {
        energyPermissionInstance = [[EnergyFunctionPermission alloc] init];
        
        [EnergyFunctionPermission initFunctionPermission];
    }
    return energyPermissionInstance;
}

- (instancetype) init {
    self = [super initWithKey:ENERGY_FUNCTION];
    if(self) {
    }
    return self;
}



//获取模块的访问权限
- (FunctionAccessPermissionType) getPermissionType {
    FunctionAccessPermissionType type = [super getPermissionType];
    return type;
}

//根据键值获取子模块的访问权限
- (FunctionAccessPermissionType) getPermisstionTypeOfSubFunctionByKey:(NSString *) key {
    FunctionAccessPermissionType type = [super getPermisstionTypeOfSubFunctionByKey:key];
    return type;
}

//初始化本模块的权限配置
+ (void) initFunctionPermission {
    
    //模块权限
    [energyPermissionInstance setPermissionType:FUNCTION_ACCESS_PERMISSION_NONE];
    
//    //子模块权限
//    //处理任务
//    FunctionItem * item = [[FunctionItem alloc] init];
//    item.key = ENERGY_SUB_FUNCTION_TASK;
//    item.name = nil;
//    item.iconName = nil;
//    item.entryClass = nil;
//    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
//    item.isFormal = YES;
//    [energyPermissionInstance addOrUpdateSubFunction:item];
    
    
}

@end
