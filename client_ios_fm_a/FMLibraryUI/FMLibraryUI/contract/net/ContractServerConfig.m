//
//  ContractServerConfig.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ContractServerConfig.h"
#import "FMTheme.h"
#import "BaseBundle.h"

//合同管理
NSString * const CONTRACT_MANAGEMENT_URL = @"/m/v1/contract/undo";

//合同查询
NSString * const CONTRACT_QUERY_URL = @"/m/v1/contract/query";

//合同详情
NSString * const CONTRACT_DETAIL_URL = @"/m/v1/contract/detail";

//查询合同关联设备列表
NSString * const CONTRACT_QUERY_EQUIPMENT_LIST_URL = @"/m/v1/contract/equipment";

//合同信息统计
NSString * const CONTRACT_STATISTICS_URL = @"/m/v1/contract/statistics";

//合同操作接口
NSString * const CONTRACT_OPERATE_URL = @"/m/v1/contract/operate";

@implementation ContractServerConfig

+ (NSString *) getCostTypeDesc:(ContractCostType) costType {
    NSString * res = nil;
    switch(costType) {
            
        case CONTRACT_COST_TRANSFER:
            res = [[BaseBundle getInstance] getStringByKey:@"contract_cost_type_transfer" inTable:nil];
            break;
        case CONTRACT_COST_CASH:
            res = [[BaseBundle getInstance] getStringByKey:@"contract_cost_type_cash" inTable:nil];
            break;
        case CONTRACT_COST_DRAFT:
            res = [[BaseBundle getInstance] getStringByKey:@"contract_cost_type_draft" inTable:nil];
            break;
            
        default:
            res = @"";
            break;
    }
    
    return res;

}

+ (NSString *) getStatusDesc:(ContractStatusType) status {
    NSString * res = nil;
    switch(status) {
            
        case CONTRACT_STATUS_UNDO:
            res = [[BaseBundle getInstance] getStringByKey:@"contract_status_undo" inTable:nil];
            break;
        case CONTRACT_STATUS_EXECUTING:
            res = [[BaseBundle getInstance] getStringByKey:@"contract_status_executing" inTable:nil];
            break;
        case CONTRACT_STATUS_EXPIRED:
            res = [[BaseBundle getInstance] getStringByKey:@"contract_status_expired" inTable:nil];
            break;
        case CONTRACT_STATUS_VERFIED_NO:
            res = [[BaseBundle getInstance] getStringByKey:@"contract_status_verfied_NO" inTable:nil];
            break;
        case CONTRACT_STATUS_VERFIED_YES:
            res = [[BaseBundle getInstance] getStringByKey:@"contract_status_verfied_YES" inTable:nil];
            break;
        case CONTRACT_STATUS_TERMINATED:
            res = [[BaseBundle getInstance] getStringByKey:@"contract_status_terminated" inTable:nil];
            break;
        case CONTRACT_STATUS_CLOSED:
            res = [[BaseBundle getInstance] getStringByKey:@"contract_status_closed" inTable:nil];
            break;
            
        default:
            res = @"";
            break;
    }
    
    return res;
}

//获取相应状态的颜色
+ (UIColor *) getStatusColor:(ContractStatusType) status {
    UIColor * res;
    switch(status) {
        case CONTRACT_STATUS_UNDO:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
            break;
        case CONTRACT_STATUS_EXECUTING:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
            break;
        case CONTRACT_STATUS_EXPIRED:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
            break;
        case CONTRACT_STATUS_VERFIED_NO:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
            break;
        case CONTRACT_STATUS_VERFIED_YES:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
            break;
        case CONTRACT_STATUS_TERMINATED:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
            break;
        case CONTRACT_STATUS_CLOSED:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
            break;
        
        default:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
            break;
    }
    return res;
}


//获取操作步骤描述
+ (NSString *) getOperationRecordTypeDesc:(ContractOperationRecordType) status {
    NSString * res = nil;
    switch(status) {
        case CONTRACT_OPERATION_RECORD_TYPE_CREATE:
            res = [[BaseBundle getInstance] getStringByKey:@"contract_op_status_create" inTable:nil];
            break;
        case CONTRACT_OPERATION_RECORD_TYPE_CLOSE:
            res = [[BaseBundle getInstance] getStringByKey:@"contract_op_status_close" inTable:nil];
            break;
        case CONTRACT_OPERATION_RECORD_TYPE_RECOVERY:
            res = [[BaseBundle getInstance] getStringByKey:@"contract_op_status_expired" inTable:nil];
            break;
        case CONTRACT_OPERATION_RECORD_TYPE_CHECK_UNPASS:
            res = [[BaseBundle getInstance] getStringByKey:@"contract_op_status_verfied_NO" inTable:nil];
            break;
        case CONTRACT_OPERATION_RECORD_TYPE_CHECK_PASS:
            res = [[BaseBundle getInstance] getStringByKey:@"contract_op_status_verfied_YES" inTable:nil];
            break;
        case CONTRACT_OPERATION_RECORD_TYPE_ARCHIVED:
            res = [[BaseBundle getInstance] getStringByKey:@"contract_op_status_archived" inTable:nil];
            break;
        case CONTRACT_OPERATION_RECORD_TYPE_UPDATE:
            res = [[BaseBundle getInstance] getStringByKey:@"contract_op_status_update" inTable:nil];
            break;
            
        default:
            res = @"";
            break;
    }
    
    return res;
}

//获取操作步骤颜色
+ (UIColor *) getOperationRecordTypeColor:(ContractOperationRecordType) status{
    UIColor * color;
    switch (status) {
        case CONTRACT_OPERATION_RECORD_TYPE_CREATE:
            color = [UIColor colorWithRed:0x1a/255.0 green:0xb3/255.0 blue:0x94/255.0 alpha:1];
            break;
            
        case CONTRACT_OPERATION_RECORD_TYPE_CLOSE:
            color = [UIColor colorWithRed:0xff/255.0 green:0x9f/255.0 blue:0x0e/255.0 alpha:1];
            break;
            
        case CONTRACT_OPERATION_RECORD_TYPE_RECOVERY:
            color = [UIColor colorWithRed:0x3c/255.0 green:0xbc/255.0 blue:0x70/255.0 alpha:1];
            break;
            
        case CONTRACT_OPERATION_RECORD_TYPE_CHECK_UNPASS:
            color = [UIColor colorWithRed:0xf5/255.0 green:0x58/255.0 blue:0x58/255.0 alpha:1];
            break;
            
        case CONTRACT_OPERATION_RECORD_TYPE_CHECK_PASS:
            color = [UIColor colorWithRed:0x74/255.0 green:0xbc/255.0 blue:0x3a/255.0 alpha:1];
            break;
            
        case CONTRACT_OPERATION_RECORD_TYPE_ARCHIVED:
            color = [UIColor colorWithRed:0x15/255.0 green:0x9f/255.0 blue:0xe6/255.0 alpha:1];
            break;
            
        case CONTRACT_OPERATION_RECORD_TYPE_UPDATE:
            color = [UIColor colorWithRed:0x74/255.0 green:0xbc/255.0 blue:0x3a/255.0 alpha:1];
            break;
    }
    return color;
}

+ (NSString *) getPaymentDesc:(BOOL) isPayment {
    NSString * res = @"";
    if(isPayment) {
        res = [[BaseBundle getInstance] getStringByKey:@"contract_payment_out" inTable:nil];
    } else {
        res = [[BaseBundle getInstance] getStringByKey:@"contract_payment_in" inTable:nil];
    }
    
    return res;
}

+ (UIColor *) getPaymentColor:(BOOL) isPayment {
    UIColor * color;
    if(isPayment) {
        color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
    } else {
        color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
    }
    return color;
}

+ (NSString *) getCurrencyType:(ContractMoneyType) type {
    NSString *res = nil;
    switch (type) {
        case CONTRACT_MONEY_YUAN:
            res = [[BaseBundle getInstance] getStringByKey:@"contract_currency_type_yuan" inTable:nil];
            break;
            
        case CONTRACT_MONEY_DOLLAR:
            res = [[BaseBundle getInstance] getStringByKey:@"contract_currency_type_dollar" inTable:nil];
            break;
    }
    
    return res;
}

@end
