//
//  NotificationFunctionPermission.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/5/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "FunctionPermission.h"

extern const NSString * NOTIFICATION_FUNCTION;        //推送消息模块主键

extern const NSString * NOTIFICATION_SUB_FUNCTION_QUERY;       //查询推送记录

@interface NotificationFunctionPermission : FunctionPermission

+ (instancetype) getInstance;

//获取模块的访问权限
- (FunctionAccessPermissionType) getPermissionType;

//根据键值获取子模块的访问权限
- (FunctionAccessPermissionType) getPermisstionTypeOfSubFunctionByKey:(NSString *) key;

//初始化本模块的权限配置
+ (void) initFunctionPermission;

@end
