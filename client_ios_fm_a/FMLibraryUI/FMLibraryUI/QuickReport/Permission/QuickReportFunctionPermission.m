//
//  QuickReportFunctionPermission.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/9.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "QuickReportFunctionPermission.h"
#import "PowerManager.h"
#import "BaseBundle.h"

const NSString * QUICK_REPORT_FUNCTION = @"quickreport";        //快速报障模块主键

QuickReportFunctionPermission *quickReportPermissionInstance;

@implementation QuickReportFunctionPermission

+ (instancetype) getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!quickReportPermissionInstance) {
            quickReportPermissionInstance = [[QuickReportFunctionPermission alloc] init];
            
            [QuickReportFunctionPermission initFunctionPermission];
        }
    });
    
    return quickReportPermissionInstance;
}

- (instancetype) init {
    self = [super initWithKey:QUICK_REPORT_FUNCTION];
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
    [quickReportPermissionInstance setPermissionType:FUNCTION_ACCESS_PERMISSION_ALL];
    
}

@end
