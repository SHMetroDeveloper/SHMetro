//
//  ReportFunctionPermission.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/3/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FunctionPermission.h"

extern const NSString * REPORT_FUNCTION;        //报障模块主键

extern const NSString * REPORT_SUB_FUNCTION_USE;       //报障
extern const NSString * REPORT_SUB_FUNCTION_MY;       //我的报障

@interface ReportFunctionPermission : FunctionPermission

+ (instancetype) getInstance;

//获取模块的访问权限
- (FunctionAccessPermissionType) getPermissionType;

//根据键值获取子模块的访问权限
- (FunctionAccessPermissionType) getPermisstionTypeOfSubFunctionByKey:(NSString *) key;

//初始化本模块的权限配置
+ (void) initFunctionPermission;

@end
