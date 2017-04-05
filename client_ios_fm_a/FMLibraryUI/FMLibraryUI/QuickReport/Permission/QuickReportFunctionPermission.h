//
//  QuickReportFunctionPermission.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/9.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FunctionPermission.h"
//#import "NewRequirementViewController.h"
#import "QuickReportViewController.h"


extern const NSString * QUICK_REPORT_FUNCTION;        //快速报障模块主键

@interface QuickReportFunctionPermission : FunctionPermission

+ (instancetype) getInstance;

//获取模块的访问权限
- (FunctionAccessPermissionType) getPermissionType;

//根据键值获取子模块的访问权限
- (FunctionAccessPermissionType) getPermisstionTypeOfSubFunctionByKey:(NSString *) key;

//初始化本模块的权限配置
+ (void) initFunctionPermission;

@end
