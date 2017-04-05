//
//  PlannedMaintenanceFunctionPermission.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/3/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "PlannedMaintenanceFunctionPermission.h"
#import "PowerManager.h"


const NSString * PPM_FUNCTION = @"ppm";

//const NSString * PPM_SUB_FUNCTION_CALENDAR = @"calendar";
//const NSString * PPM_SUB_FUNCTION_PROCESS = @"process";
//const NSString * PPM_SUB_FUNCTION_DETAIL = @"detail";


PlannedMaintenanceFunctionPermission * ppmPermissionInstance;

@interface PlannedMaintenanceFunctionPermission ()

@end


@implementation PlannedMaintenanceFunctionPermission
+ (instancetype) getInstance {
    if(!ppmPermissionInstance) {
        ppmPermissionInstance = [[PlannedMaintenanceFunctionPermission alloc] init];
        
        [PlannedMaintenanceFunctionPermission initFunctionPermission];
    }
    return ppmPermissionInstance;
}

- (instancetype) init {
    self = [super initWithKey:PPM_FUNCTION];
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
    [ppmPermissionInstance setPermissionType:FUNCTION_ACCESS_PERMISSION_ALL];
    
//    //子模块权限
//    //维护日历
//    FunctionItem * item = [[FunctionItem alloc] init];
//    item.key = PPM_SUB_FUNCTION_CALENDAR;
//    item.name = nil;
//    item.iconName = nil;
//    item.entryClass = nil;
//    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
//    item.isFormal = YES;
//    [ppmPermissionInstance addOrUpdateSubFunction:item];
//    
//    //步骤编辑
//    item = [[FunctionItem alloc] init];
//    item.key = PPM_SUB_FUNCTION_PROCESS;
//    item.name = nil;
//    item.iconName = nil;
//    item.entryClass = nil;
//    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
//    item.isFormal = YES;
//    [ppmPermissionInstance addOrUpdateSubFunction:item];
//    
//    //维护详情
//    item = [[FunctionItem alloc] init];
//    item.key = PPM_SUB_FUNCTION_DETAIL;
//    item.name = nil;
//    item.iconName = nil;
//    item.entryClass = nil;
//    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
//    item.isFormal = YES;
//    [ppmPermissionInstance addOrUpdateSubFunction:item];
    
}

@end
