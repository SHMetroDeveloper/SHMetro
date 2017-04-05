//
//  AttendanceFunctionPermission.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/3/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "AttendanceFunctionPermission.h"
#import "PowerManager.h"


const NSString * ATTENDANCE_FUNCTION = @"sign";        //在岗管理模块主键

//const NSString * ATTENDANCE_SUB_FUNCTION_USE = @"use";         //签到
//const NSString * ATTENDANCE_SUB_FUNCTION_SETTING = @"setting";     //签到设置
//const NSString * ATTENDANCE_SUB_FUNCTION_QUERY = @"query";       //查看签到记录


AttendanceFunctionPermission * attendancePermissionInstance;

@interface AttendanceFunctionPermission ()

@end


@implementation AttendanceFunctionPermission
+ (instancetype) getInstance {
    if(!attendancePermissionInstance) {
        attendancePermissionInstance = [[AttendanceFunctionPermission alloc] init];
        
        [AttendanceFunctionPermission initFunctionPermission];
    }
    return attendancePermissionInstance;
}

- (instancetype) init {
    self = [super initWithKey:ATTENDANCE_FUNCTION];
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
    [attendancePermissionInstance setPermissionType:FUNCTION_ACCESS_PERMISSION_NONE];
    
//    //子模块权限
//    //签到
//    FunctionItem * item = [[FunctionItem alloc] init];
//    item.key = ATTENDANCE_SUB_FUNCTION_USE;
//    item.name = nil;
//    item.iconName = nil;
//    item.entryClass = nil;
//    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
//    item.isFormal = YES;
//    [attendancePermissionInstance addOrUpdateSubFunction:item];
//    
//    //设置
//    item = [[FunctionItem alloc] init];
//    item.key = ATTENDANCE_SUB_FUNCTION_SETTING;
//    item.name = nil;
//    item.iconName = nil;
//    item.entryClass = nil;
//    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
//    item.isFormal = YES;
//    [attendancePermissionInstance addOrUpdateSubFunction:item];
//    
//    //查询
//    item = [[FunctionItem alloc] init];
//    item.key = ATTENDANCE_SUB_FUNCTION_QUERY;
//    item.name = nil;
//    item.iconName = nil;
//    item.entryClass = nil;
//    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
//    item.isFormal = NO;
//    [attendancePermissionInstance addOrUpdateSubFunction:item];
}

@end
