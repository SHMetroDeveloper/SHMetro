//
//  WorkOrderFunctionPermission.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/2/29.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkOrderFunctionPermission.h"
#import "PowerManager.h"
#import "BaseBundle.h"

#import "UndoWorkOrderViewController.h"
#import "OrderUnValidatedViewController.h"
#import "DispachOrderViewController.h"
#import "ApprovalOrderViewController.h"
#import "WorkOrderDetailViewController.h"
#import "OrderUnClosedViewController.h"
#import "WorkOrderHistoryViewController.h"

const NSString * WORK_ORDER_FUNCTION = @"wo";

const NSString * WORK_ORDER_SUB_FUNCTION_UNDO = @"process";
const NSString * WORK_ORDER_SUB_FUNCTION_DISPACH = @"dispach";
const NSString * WORK_ORDER_SUB_FUNCTION_APPROVAL = @"approval";
const NSString * WORK_ORDER_SUB_FUNCTION_VALIDATE = @"validate";
const NSString * WORK_ORDER_SUB_FUNCTION_CLOSE = @"close";
const NSString * WORK_ORDER_SUB_FUNCTION_QUERY = @"query";
const NSString * WORK_ORDER_SUB_FUNCTION_DETAIL = @"detail";
const NSString * WORK_ORDER_SUB_FUNCTION_GRAB = @"grab";



WorkOrderFunctionPermission * woPermissionInstance;

@interface WorkOrderFunctionPermission ()

@end


@implementation WorkOrderFunctionPermission
+ (instancetype) getInstance {
    if(!woPermissionInstance) {
        woPermissionInstance = [[WorkOrderFunctionPermission alloc] init];
        
        [WorkOrderFunctionPermission initFunctionPermission];
    }
    return woPermissionInstance;
}

- (instancetype) init {
    self = [super initWithKey:WORK_ORDER_FUNCTION];
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
    [woPermissionInstance setPermissionType:FUNCTION_ACCESS_PERMISSION_ALL];
    
    //子模块权限
    //待处理工单
    FunctionItem * item = [[FunctionItem alloc] init];
    item.key = WORK_ORDER_SUB_FUNCTION_UNDO;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_order_undo" inTable:nil];
    item.iconName = @"order_function_undo";
    item.entryClass = [UndoWorkOrderViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_ALL;
    item.isFormal = YES;
    [woPermissionInstance addOrUpdateSubFunction:item];
    
    //待派工工单
    item = [[FunctionItem alloc] init];
    item.key = WORK_ORDER_SUB_FUNCTION_DISPACH;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_order_dispach" inTable:nil];
    item.iconName = @"order_function_dispach";
    item.entryClass = [DispachOrderViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_ALL;
    item.isFormal = YES;
    [woPermissionInstance addOrUpdateSubFunction:item];
    
    //待审批工单
    item = [[FunctionItem alloc] init];
    item.key = WORK_ORDER_SUB_FUNCTION_APPROVAL;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_order_approval" inTable:nil];
    item.iconName = @"order_function_approval";
    item.entryClass = [ApprovalOrderViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_ALL;
    item.isFormal = YES;
    [woPermissionInstance addOrUpdateSubFunction:item];
    
    //待验证工单
    item = [[FunctionItem alloc] init];
    item.key = WORK_ORDER_SUB_FUNCTION_VALIDATE;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_order_validate" inTable:nil];
    item.iconName = @"order_function_validate";
    item.entryClass = [OrderUnValidatedViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
    item.isFormal = YES;
    [woPermissionInstance addOrUpdateSubFunction:item];
    
    //待存档工单
    item = [[FunctionItem alloc] init];
    item.key = WORK_ORDER_SUB_FUNCTION_CLOSE;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_order_close" inTable:nil];
    item.iconName = @"order_function_close";
    item.entryClass = [OrderUnClosedViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_ALL;
    item.isFormal = YES;
    [woPermissionInstance addOrUpdateSubFunction:item];
    
    //工单查询
    item = [[FunctionItem alloc] init];
    item.key = WORK_ORDER_SUB_FUNCTION_QUERY;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_order_query" inTable:nil];
    item.iconName = @"function_query";
    item.entryClass = [WorkOrderHistoryViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_ALL;
    item.isFormal = YES;
    [woPermissionInstance addOrUpdateSubFunction:item];
    
    //待抢工单
    item = [[FunctionItem alloc] init];
    item.key = WORK_ORDER_SUB_FUNCTION_GRAB;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_order_grab" inTable:nil];
    item.iconName = @"order_function_grab";
    item.entryClass = nil;
    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
    item.isFormal = YES;
    [woPermissionInstance addOrUpdateSubFunction:item];
    
    //工单详情
    item = [[FunctionItem alloc] init];
    item.key = WORK_ORDER_SUB_FUNCTION_DETAIL;
    item.name = nil;
    item.iconName = nil;
    item.entryClass = [WorkOrderDetailViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
    item.isFormal = NO;
    [woPermissionInstance addOrUpdateSubFunction:item];
}

@end
