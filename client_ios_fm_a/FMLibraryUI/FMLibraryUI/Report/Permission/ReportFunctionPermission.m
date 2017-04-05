//
//  ReportFunctionPermission.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/3/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "ReportFunctionPermission.h"
#import "PowerManager.h"


const NSString * REPORT_FUNCTION = @"report";

const NSString * REPORT_SUB_FUNCTION_USE = @"use";       //报障
const NSString * REPORT_SUB_FUNCTION_MY = @"my";       //我的报障

ReportFunctionPermission * reportPermissionInstance;

@interface ReportFunctionPermission ()

@end


@implementation ReportFunctionPermission
+ (instancetype) getInstance {
    if(!reportPermissionInstance) {
        reportPermissionInstance = [[ReportFunctionPermission alloc] init];
        
        [ReportFunctionPermission initFunctionPermission];
    }
    return reportPermissionInstance;
}

- (instancetype) init {
    self = [super initWithKey:REPORT_FUNCTION];
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
    [reportPermissionInstance setPermissionType:FUNCTION_ACCESS_PERMISSION_NONE];
    
    //子模块权限
    //报障
    FunctionItem * item = [[FunctionItem alloc] init];
    item.key = REPORT_SUB_FUNCTION_USE;
    item.name = nil;
    item.iconName = nil;
    item.entryClass = nil;
    item.permissionType = FUNCTION_ACCESS_PERMISSION_ALL;
    item.isFormal = YES;
    [reportPermissionInstance addOrUpdateSubFunction:item];
    
    //我的报障
    item = [[FunctionItem alloc] init];
    item.key = REPORT_SUB_FUNCTION_MY;
    item.name = nil;
    item.iconName = nil;
    item.entryClass = nil;
    item.permissionType = FUNCTION_ACCESS_PERMISSION_ALL;
    item.isFormal = YES;
    [reportPermissionInstance addOrUpdateSubFunction:item];
}

@end
