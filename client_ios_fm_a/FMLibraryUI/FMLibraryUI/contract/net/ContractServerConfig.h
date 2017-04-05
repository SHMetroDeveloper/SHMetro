//
//  ContractServerConfig.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//合同状态类型
typedef NS_ENUM(NSInteger, ContractStatusType) {
    CONTRACT_STATUS_UNDO,   //未开始
    CONTRACT_STATUS_EXECUTING,   //执行中
    CONTRACT_STATUS_EXPIRED,   //已到期
    CONTRACT_STATUS_VERFIED_NO,  //已验收（不通过）
    CONTRACT_STATUS_VERFIED_YES,   //已验收（通过）
    CONTRACT_STATUS_TERMINATED,   //已终止
    CONTRACT_STATUS_CLOSED,   //已存档
};

//合同操作类型
typedef NS_ENUM(NSInteger, ContractOperationType) {
    CONTRACT_OPERATION_TYPE_CLOSE = 0,   //关闭
    CONTRACT_OPERATION_TYPE_RECOVERY = 1,   //恢复
    CONTRACT_OPERATION_TYPE_CHECK_UNPASS = 2,   //验收（不通过）
    CONTRACT_OPERATION_TYPE_CHECK_PASS = 3,   //验收（通过）
    CONTRACT_OPERATION_TYPE_ARCHIVED = 4   //归档
};

//合同操作记录类型
typedef NS_ENUM(NSInteger, ContractOperationRecordType) {
    CONTRACT_OPERATION_RECORD_TYPE_CREATE = 0,  //创建
    CONTRACT_OPERATION_RECORD_TYPE_CLOSE = 1,   //关闭
    CONTRACT_OPERATION_RECORD_TYPE_RECOVERY = 2,   //恢复
    CONTRACT_OPERATION_RECORD_TYPE_CHECK_UNPASS = 3,   //验收（不通过）
    CONTRACT_OPERATION_RECORD_TYPE_CHECK_PASS = 4,   //验收（通过）
    CONTRACT_OPERATION_RECORD_TYPE_ARCHIVED = 5,   //归档
    CONTRACT_OPERATION_RECORD_TYPE_UPDATE = 6,   //更新
};


//合同支付方式
typedef NS_ENUM(NSInteger, ContractCostType) {
    CONTRACT_COST_TRANSFER,   //转账
    CONTRACT_COST_CASH,   //现金
    CONTRACT_COST_DRAFT,   //汇票
};

//金币类型
typedef NS_ENUM(NSInteger, ContractMoneyType) {
    CONTRACT_MONEY_YUAN,   //人民币
    CONTRACT_MONEY_DOLLAR,   //美元
};

@interface ContractServerConfig : NSObject

//获取支付类型
+ (NSString *) getCostTypeDesc:(ContractCostType) costType;

//获取货币类型
+ (NSString *) getCurrencyType:(ContractMoneyType) type;

//获取状态描述
+ (NSString *) getStatusDesc:(ContractStatusType) status;

//获取状态颜色
+ (UIColor *) getStatusColor:(ContractStatusType) status;


//获取操作步骤描述
+ (NSString *) getOperationRecordTypeDesc:(ContractOperationRecordType) status;

//获取操作步骤颜色
+ (UIColor *) getOperationRecordTypeColor:(ContractOperationRecordType) status;

//获取收款付款描述
+ (NSString *) getPaymentDesc:(BOOL) isPayment;

//获取收款付款颜色
+ (UIColor *) getPaymentColor:(BOOL) isPayment;

@end

//合同管理
extern NSString * const CONTRACT_MANAGEMENT_URL;

//合同查询
extern NSString * const CONTRACT_QUERY_URL;

//合同详情
extern NSString * const CONTRACT_DETAIL_URL;

//查询合同关联设备列表
extern NSString * const CONTRACT_QUERY_EQUIPMENT_LIST_URL;

//合同信息统计
extern NSString * const CONTRACT_STATISTICS_URL;

//合同操作接口
extern NSString * const CONTRACT_OPERATE_URL;
