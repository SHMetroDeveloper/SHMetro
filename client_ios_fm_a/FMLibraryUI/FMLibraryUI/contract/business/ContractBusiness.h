//
//  ContractBusiness.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "BaseBusiness.h"
#import "ContractEntity.h"
#import "ContractDetailEntity.h"
#import "ContractEquipment.h"
#import "ContractStatisticsEntity.h"
#import "ContractOperateEntity.h"

typedef NS_ENUM(NSInteger, WorkOrderBusinessType) {
    BUSINESS_CONTRACT_UNKNOW,   //
    BUSINESS_CONTRACT_MANAGEMENT,       //查询合同管理列表
    BUSINESS_CONTRACT_QUERY,       //查询合同列表
    BUSINESS_CONTRACT_DETAIL,    //查询合同详情
    BUSINESS_CONTRACT_EQUIPMENT,   //查询合同相关设备列表
    BUSINESS_CONTRACT_STATISTICS,   //查询合同统计信息
    BUSINESS_CONTRACT_OPERATE,   //合同操作（关闭，恢复，验收，存档）
};

@interface ContractBusiness : BaseBusiness
//获取合同业务的实例对象
+ (instancetype) getInstance;

//获取待处理合同列表
- (void) getContractManagementListByPage:(NetPageParam *) page success:(business_success_block) success fail:(business_failure_block) fail;

//查询合同列表
- (void) getContractListByCondition:(ContractQueryCondition *) condition andPage:(NetPageParam *) page success:(business_success_block) success fail:(business_failure_block) fail;

//查询合同详情
- (void) getDetailInfoOfContract:(NSNumber *) contractId success:(business_success_block) success fail:(business_failure_block) fail;

//查询合同设备列表
- (void) getEquipmentListOfContract:(NSNumber *) contractId andPage:(NetPage *) page success:(business_success_block) success fail:(business_failure_block) fail;

//查询合同统计信息
- (void) getContractStatisticsSuccess:(business_success_block) success fail:(business_failure_block) fail;

//合同操作（关闭，恢复，验收，存档）
- (void) operateContractByParam:(ContractOperateRequestParam *)param Success:(business_success_block) success fail:(business_failure_block) fail;

@end
