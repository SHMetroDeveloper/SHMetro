//
//  ContractFunctionPermission.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ContractFunctionPermission.h"
#import "PowerManager.h"
#import "ContractQueryViewController.h"
#import "ContractStatisticsViewController.h"
#import "ContractManagementViewController.h"

const NSString * CONTRACT_FUNCTION = @"contract";

const NSString * CONTRACT_SUB_FUNCTION_PROCESS = @"process";
const NSString * CONTRACT_SUB_FUNCTION_QUERY = @"query";

ContractFunctionPermission * contractPermissionInstance;

@implementation ContractFunctionPermission

+ (instancetype) getInstance {
    if(!contractPermissionInstance) {
        contractPermissionInstance = [[ContractFunctionPermission alloc] init];
        
        [ContractFunctionPermission initFunctionPermission];
    }
    return contractPermissionInstance;
}

- (instancetype) init {
    self = [super initWithKey:CONTRACT_FUNCTION];
    if(self) {
    }
    return self;
}

//初始化本模块的权限配置
+ (void) initFunctionPermission {
    
    //模块权限
    [contractPermissionInstance setPermissionType:FUNCTION_ACCESS_PERMISSION_NONE];
    
    //子模块权限
    //合同管理
    FunctionItem * item = [[FunctionItem alloc] init];
    item.key = CONTRACT_SUB_FUNCTION_PROCESS;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_contract_process" inTable:nil];
    item.iconName = @"contract_function_management";
    item.entryClass = [ContractManagementViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
    item.isFormal = YES;
    [contractPermissionInstance addSubFunction:item];
    
    //合同查询
    item = [[FunctionItem alloc] init];
    item.key = CONTRACT_SUB_FUNCTION_QUERY;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_contract_query" inTable:nil];
    item.iconName = @"function_query";
    item.entryClass = [ContractQueryViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
    item.isFormal = YES;
    [contractPermissionInstance addSubFunction:item];
   
}

@end
