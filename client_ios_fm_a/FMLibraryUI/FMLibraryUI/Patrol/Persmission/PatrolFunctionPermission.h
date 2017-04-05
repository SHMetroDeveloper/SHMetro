//
//  PatrolFunctionPermission.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/5/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "FunctionPermission.h"

extern const NSString * PATROL_FUNCTION;        //巡检模块主键

extern const NSString * PATROL_SUB_FUNCTION_TASK;       //巡检任务
extern const NSString * PATROL_SUB_FUNCTION_QUERY;    //巡检查询

@interface PatrolFunctionPermission : FunctionPermission

+ (instancetype) getInstance;

//获取模块的访问权限
- (FunctionAccessPermissionType) getPermissionType;

//根据键值获取子模块的访问权限
- (FunctionAccessPermissionType) getPermisstionTypeOfSubFunctionByKey:(NSString *) key;

//初始化本模块的权限配置
+ (void) initFunctionPermission;

@end