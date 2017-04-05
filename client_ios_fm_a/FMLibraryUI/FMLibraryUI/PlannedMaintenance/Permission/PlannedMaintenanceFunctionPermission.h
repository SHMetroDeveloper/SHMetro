//
//  PlannedMaintenanceFunctionPermission.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/3/17.
//  Copyright © 2017 facilityone. All rights reserved.
//


#import "FunctionPermission.h"

extern const NSString * PPM_FUNCTION;        //计划性维护模块主键

//extern const NSString * PPM_SUB_FUNCTION_CALENDAR;       //日历
//extern const NSString * PPM_SUB_FUNCTION_PROCESS;    //编辑维护步骤
//extern const NSString * PPM_SUB_FUNCTION_DETAIL;    //查看维护详情

@interface PlannedMaintenanceFunctionPermission : FunctionPermission

+ (instancetype) getInstance;

//获取模块的访问权限
- (FunctionAccessPermissionType) getPermissionType;

//根据键值获取子模块的访问权限
- (FunctionAccessPermissionType) getPermisstionTypeOfSubFunctionByKey:(NSString *) key;

//初始化本模块的权限配置
+ (void) initFunctionPermission;

@end
