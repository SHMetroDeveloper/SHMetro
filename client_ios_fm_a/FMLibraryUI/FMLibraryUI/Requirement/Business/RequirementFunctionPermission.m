//
//  RequirementFunctionPermission.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 6/30/16.
//  Copyright © 2016 flynn. All rights reserved.
//

#import "RequirementFunctionPermission.h"
#import "PowerManager.h"

#import "NewRequirementViewController.h"
#import "RequirementHistoryViewController.h"
#import "EvaluateRequirementViewController.h"
#import "UndoRequirementViewController.h"
#import "ApprovalRequirementViewController.h"
#import "RequirementDetailViewController.h"
#import "BaseBundle.h"


const NSString * REQUIREMENT_FUNCTION = @"requirement";

const NSString * REQUIREMENT_SUB_FUNCTION_CREATE = @"create";       //创建需求
const NSString * REQUIREMENT_SUB_FUNCTION_UNDO = @"process";    //待处理需求
const NSString * REQUIREMENT_SUB_FUNCTION_APPROVAL = @"approval";   //待审核需求
const NSString * REQUIREMENT_SUB_FUNCTION_EVALUATE = @"evaluate";   //待评价需求
const NSString * REQUIREMENT_SUB_FUNCTION_QUERY = @"query";      //需求查询
const NSString * REQUIREMENT_SUB_FUNCTION_DETAIL = @"detail";     //需求详情



RequirementFunctionPermission * requirementPermissionInstance;

@interface RequirementFunctionPermission ()
@end


@implementation RequirementFunctionPermission

+ (instancetype) getInstance {
    if(!requirementPermissionInstance) {
        requirementPermissionInstance = [[RequirementFunctionPermission alloc] init];
        [RequirementFunctionPermission initFunctionPermission];
    }
    return requirementPermissionInstance;
}

- (instancetype) init {
    self = [super initWithKey:REQUIREMENT_FUNCTION];
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
    [requirementPermissionInstance setPermissionType:FUNCTION_ACCESS_PERMISSION_ALL];
    
    //子模块权限
    //创建需求
    FunctionItem * item = [[FunctionItem alloc] init];
    item.key = REQUIREMENT_SUB_FUNCTION_CREATE;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_requirement_create" inTable:nil];
    item.iconName = @"requirement_function_create";
    item.entryClass = [NewRequirementViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_ALL;
    item.isFormal = YES;
    [requirementPermissionInstance addOrUpdateSubFunction:item];
    
    //待审批需求
    item = [[FunctionItem alloc] init];
    item.key = REQUIREMENT_SUB_FUNCTION_APPROVAL;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_requirement_approval" inTable:nil];
    item.iconName = @"requirement_function_approval";
    item.entryClass = [ApprovalRequirementViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_ALL;
    item.isFormal = YES;
    [requirementPermissionInstance addOrUpdateSubFunction:item];
    
    //待处理需求
    item = [[FunctionItem alloc] init];
    item.key = REQUIREMENT_SUB_FUNCTION_UNDO;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_requirement_undo" inTable:nil];
    item.iconName = @"requirement_function_undo";
    item.entryClass = [UndoRequirementViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_ALL;
    item.isFormal = YES;
    [requirementPermissionInstance addOrUpdateSubFunction:item];
    
    //待评价需求
    item = [[FunctionItem alloc] init];
    item.key = REQUIREMENT_SUB_FUNCTION_EVALUATE;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_requirement_evaluate" inTable:nil];
    item.iconName = @"requirement_function_evaluate";
    item.entryClass = [EvaluateRequirementViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_ALL;
    item.isFormal = YES;
    [requirementPermissionInstance addOrUpdateSubFunction:item];
    
    //需求查询
    item = [[FunctionItem alloc] init];
    item.key = REQUIREMENT_SUB_FUNCTION_QUERY;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_requirement_query" inTable:nil];
    item.iconName = @"function_query";
    item.entryClass = [RequirementHistoryViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_ALL;
    item.isFormal = YES;
    [requirementPermissionInstance addOrUpdateSubFunction:item];
    
    //需求详情
    item = [[FunctionItem alloc] init];
    item.key = REQUIREMENT_SUB_FUNCTION_DETAIL;
    item.name = nil;
    item.iconName = nil;
    item.entryClass = [RequirementDetailViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_ALL;
    item.isFormal = NO;
    [requirementPermissionInstance addOrUpdateSubFunction:item];
}

@end

