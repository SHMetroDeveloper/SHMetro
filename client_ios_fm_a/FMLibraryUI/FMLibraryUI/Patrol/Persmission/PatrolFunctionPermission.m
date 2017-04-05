//
//  PatrolFunctionPermission.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/5/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "PatrolFunctionPermission.h"
#import "PowerManager.h"
#import "PatrolTaskUnFinishedViewController.h"
#import "PatrolTaskHistoryViewController.h"
#import "BaseBundle.h"


const NSString * PATROL_FUNCTION = @"patrol";

const NSString * PATROL_SUB_FUNCTION_TASK = @"task";
const NSString * PATROL_SUB_FUNCTION_QUERY = @"query";



PatrolFunctionPermission * patrolPermissionInstance;

@interface PatrolFunctionPermission ()

@end


@implementation PatrolFunctionPermission


+ (instancetype) getInstance {
    if(!patrolPermissionInstance) {
        patrolPermissionInstance = [[PatrolFunctionPermission alloc] init];
        
        [PatrolFunctionPermission initFunctionPermission];
    }
    return patrolPermissionInstance;
}

- (instancetype) init {
    self = [super initWithKey:PATROL_FUNCTION];
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
    [patrolPermissionInstance setPermissionType:FUNCTION_ACCESS_PERMISSION_ALL];
    
    //子模块权限
    //巡检任务
    FunctionItem * item = [[FunctionItem alloc] init];
    item.key = PATROL_SUB_FUNCTION_TASK;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_patrol_task" inTable:nil];
    item.iconName = @"home_function_patrol";
    item.entryClass = [PatrolTaskUnFinishedViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_ALL;
    item.isFormal = YES;
    [patrolPermissionInstance addOrUpdateSubFunction:item];
    
    //巡检查询
    item = [[FunctionItem alloc] init];
    item.key = PATROL_SUB_FUNCTION_QUERY;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_patrol_query" inTable:nil];
    item.iconName = @"function_query";
    item.entryClass = [PatrolTaskHistoryViewController class];
    item.isFormal = YES;
    item.permissionType = FUNCTION_ACCESS_PERMISSION_ALL;
    [patrolPermissionInstance addOrUpdateSubFunction:item];
    
}

@end

