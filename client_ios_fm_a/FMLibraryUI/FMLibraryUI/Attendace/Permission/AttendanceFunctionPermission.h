//
//  AttendanceFunctionPermission.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/3/17.
//  Copyright © 2017 facilityone. All rights reserved.
//


#import "FunctionPermission.h"

extern const NSString * ATTENDANCE_FUNCTION;        //在岗管理模块主键

//extern const NSString * ATTENDANCE_SUB_FUNCTION_USE;         //签到
//extern const NSString * ATTENDANCE_SUB_FUNCTION_SETTING;     //签到设置
//extern const NSString * ATTENDANCE_SUB_FUNCTION_QUERY;       //查看签到记录

@interface AttendanceFunctionPermission : FunctionPermission

+ (instancetype) getInstance;

//获取模块的访问权限
- (FunctionAccessPermissionType) getPermissionType;

//根据键值获取子模块的访问权限
- (FunctionAccessPermissionType) getPermisstionTypeOfSubFunctionByKey:(NSString *) key;

//初始化本模块的权限配置
+ (void) initFunctionPermission;

@end
