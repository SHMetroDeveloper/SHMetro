//
//  ContractBusiness.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ContractBusiness.h"
#import "ContractNetRequest.h"
#import "ContractServerConfig.h"
#import "MJExtension.h"

ContractBusiness * contractBusinessInstance;

@interface ContractBusiness ()
@property (readwrite, nonatomic, strong) ContractNetRequest * netRequest;
@end

@implementation ContractBusiness

//获取合同业务的实例对象
+ (instancetype) getInstance {
    if(!contractBusinessInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            contractBusinessInstance = [[ContractBusiness alloc] init];
        });
    }
    return contractBusinessInstance;
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _netRequest = [ContractNetRequest getInstance];
    }
    return self;
}

//获取待处理合同列表
- (void) getContractManagementListByPage:(NetPageParam *) page success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        ContractManagementParam * param = [[ContractManagementParam alloc] initWithPage:page];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            ContractQueryResponse * response = [ContractQueryResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_CONTRACT_MANAGEMENT, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_CONTRACT_MANAGEMENT, error);
            }
        }];
    }
}

//查询合同列表
- (void) getContractListByCondition:(ContractQueryCondition *) condition andPage:(NetPageParam *) page success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        ContractQueryParam * param = [[ContractQueryParam alloc] initWithCondition:condition andPage:page];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            ContractQueryResponse * response = [ContractQueryResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_CONTRACT_QUERY, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_CONTRACT_QUERY, error);
            }
        }];
    }
}

//查询合同详情
- (void) getDetailInfoOfContract:(NSNumber *) contractId success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        ContractDetailRequestParam * param = [[ContractDetailRequestParam alloc] initWithContractId:contractId];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            ContractDetailRequestResponse * response = [ContractDetailRequestResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_CONTRACT_DETAIL, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_CONTRACT_DETAIL, error);
            }
        }];
    }
}

//查询合同设备列表
- (void) getEquipmentListOfContract:(NSNumber *) contractId andPage:(NetPage *) page success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        ContractEquipmentRequestParam *param = [[ContractEquipmentRequestParam alloc] initWithContractId:contractId andPage:page];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            ContractEquipmentResponse * response = [ContractEquipmentResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_CONTRACT_EQUIPMENT, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_CONTRACT_EQUIPMENT, error);
            }
        }];
    }
}

//查询合同统计信息
- (void) getContractStatisticsSuccess:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        ContractStatisticsRequestParam * param = [[ContractStatisticsRequestParam alloc] init];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            ContractStatisticsResponse * response = [ContractStatisticsResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_CONTRACT_STATISTICS, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_CONTRACT_STATISTICS, error);
            }
        }];
    }
}

//合同操作（关闭，恢复，验收，存档）
- (void) operateContractByParam:(ContractOperateRequestParam *)param Success:(business_success_block) success fail:(business_failure_block) fail{
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_CONTRACT_OPERATE, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_CONTRACT_OPERATE, error);
            }
        }];
    }
}

@end
