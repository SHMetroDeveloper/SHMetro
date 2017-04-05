//
//  ContractFunctionPermission.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "FunctionPermission.h"

extern const NSString * CONTRACT_FUNCTION;        //合同模块主键

extern const NSString * CONTRACT_SUB_FUNCTION_PROCESS;      //合同管理
extern const NSString * CONTRACT_SUB_FUNCTION_QUERY;       //合同查询

@interface ContractFunctionPermission : FunctionPermission

+ (instancetype) getInstance;


//初始化本模块的权限配置
+ (void) initFunctionPermission;

@end
