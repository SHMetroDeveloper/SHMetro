//
//  CommonBusiness.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/5/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "CommonBusiness.h"
#import "BaseDataNetRequest.h"
#import "MJExtension.h"

CommonBusiness * commonBusinessInstance;

@interface CommonBusiness ()

@property (readwrite, nonatomic, strong) BaseDataNetRequest * netRequest;

@end

@implementation CommonBusiness

+ (instancetype) getInstance {
    if(!commonBusinessInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            commonBusinessInstance = [[CommonBusiness alloc] init];
        });
    }
    return commonBusinessInstance;
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _netRequest = [BaseDataNetRequest getInstance];
    }
    return self;
}

//请求待处理的任务的数量
- (void) getTaskCountUndo:(BaseDataGetUndoTaskCountParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            UndoTaskResponse * response = [UndoTaskResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_COMMON_GET_TASK_COUNT_UNDO, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_COMMON_GET_TASK_COUNT_UNDO, error);
            }
        }];
    }
}

//请求故障原因列表
- (void) getFailureReasonByParam:(BaseDataGetFailureReasonRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            BaseDataGetFailureReasonResponse * response = [BaseDataGetFailureReasonResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_COMMON_GET_FAILURE_REASON, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_COMMON_GET_FAILURE_REASON, error);
            }
        }];
    }
}


//请求流程信息
- (void) getFlowByParam:(BaseDataGetFlowListRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            BaseDataGetFlowListRequestResponse * response = [BaseDataGetFlowListRequestResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_COMMON_GET_FLOW, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_COMMON_GET_FLOW, error);
            }
        }];
    }
}


//请求设备信息
- (void) getEquipmentByParam:(BaseDataGetDeviceListRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            BaseDataGetDeviceListRequestResponse * response = [BaseDataGetDeviceListRequestResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_COMMON_GET_EQUIPMENT, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_COMMON_GET_EQUIPMENT, error);
            }
        }];
    }
}


//请求站点和区间信息
- (void) getBuildingByParam:(BaseDataGetBuildingListRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            BaseDataGetBuildingListRequestResponse * response = [BaseDataGetBuildingListRequestResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_COMMON_GET_BUILDDING, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_COMMON_GET_BUILDDING, error);
            }
        }];
    }
}

//获取基础数据的更新记录
- (void) getBaseDataUpdateRecordByTime:(NSNumber *) time
                               success:(business_success_block)success
                                  fail:(business_failure_block)fail {
    BaseDataGetUpdateRecordRequestParam *param = [[BaseDataGetUpdateRecordRequestParam alloc] initWith:time];
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            
            BaseDataGetUpdateRecordResponse * response = [BaseDataGetUpdateRecordResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_COMMON_GET_BASE_DATA_UPDATE_RECORD, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if(fail) {
                
                fail(BUSINESS_COMMON_GET_BASE_DATA_UPDATE_RECORD, error);
            }
        }];
    }
}
@end
