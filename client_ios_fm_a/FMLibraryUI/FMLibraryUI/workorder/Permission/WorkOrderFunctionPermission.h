//
//  WorkOrderFunctionPermission.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/2/29.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "FunctionPermission.h"

extern const NSString * WORK_ORDER_FUNCTION;        //工单模块主键

extern const NSString * WORK_ORDER_SUB_FUNCTION_UNDO;       //待处理工单
extern const NSString * WORK_ORDER_SUB_FUNCTION_DISPACH;    //待派工工单
extern const NSString * WORK_ORDER_SUB_FUNCTION_APPROVAL;   //待审核工单
extern const NSString * WORK_ORDER_SUB_FUNCTION_VALIDATE;   //待验证工单
extern const NSString * WORK_ORDER_SUB_FUNCTION_CLOSE;      //待存档工单
extern const NSString * WORK_ORDER_SUB_FUNCTION_QUERY;      //工单查询
extern const NSString * WORK_ORDER_SUB_FUNCTION_DETAIL;     //工单详情
extern const NSString * WORK_ORDER_SUB_FUNCTION_GRAB;       //待抢工单

@interface WorkOrderFunctionPermission : FunctionPermission

+ (instancetype) getInstance;

//获取模块的访问权限
- (FunctionAccessPermissionType) getPermissionType;

//根据键值获取子模块的访问权限
- (FunctionAccessPermissionType) getPermisstionTypeOfSubFunctionByKey:(NSString *) key;

//初始化本模块的权限配置
+ (void) initFunctionPermission;

@end
