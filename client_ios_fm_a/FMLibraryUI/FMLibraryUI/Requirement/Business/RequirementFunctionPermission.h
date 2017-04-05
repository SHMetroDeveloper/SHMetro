//
//  RequirementFunctionPermission.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 6/30/16.
//  Copyright © 2016 flynn. All rights reserved.
//

#import "FunctionPermission.h"

extern const NSString * REQUIREMENT_FUNCTION;        //需求模块主键

extern const NSString * REQUIREMENT_SUB_FUNCTION_CREATE;       //创建需求
extern const NSString * REQUIREMENT_SUB_FUNCTION_UNDO;    //待处理需求
extern const NSString * REQUIREMENT_SUB_FUNCTION_APPROVAL;   //待审核需求
extern const NSString * REQUIREMENT_SUB_FUNCTION_EVALUATE;   //待评价需求
extern const NSString * REQUIREMENT_SUB_FUNCTION_QUERY;      //需求查询
extern const NSString * REQUIREMENT_SUB_FUNCTION_DETAIL;     //需求详情

@interface RequirementFunctionPermission : FunctionPermission

+ (instancetype) getInstance;

//获取模块的访问权限
- (FunctionAccessPermissionType) getPermissionType;

//根据键值获取子模块的访问权限
- (FunctionAccessPermissionType) getPermisstionTypeOfSubFunctionByKey:(NSString *) key;

//初始化本模块的权限配置
+ (void) initFunctionPermission;

@end

