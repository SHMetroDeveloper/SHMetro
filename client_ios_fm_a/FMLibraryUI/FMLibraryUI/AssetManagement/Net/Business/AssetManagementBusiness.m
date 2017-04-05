//
//  AssetManagementBusiness.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/2.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "AssetManagementBusiness.h"
#import "AssetManagemantNetRequest.h"
#import "MJExtension.h"


static AssetManagementBusiness * instance = nil;

@interface AssetManagementBusiness ()

@property (readonly, nonatomic, strong) AssetManagemantNetRequest * netRequest;

@end

@implementation AssetManagementBusiness

- (instancetype)init {
    self = [super init];
    if (self) {
        _netRequest = [AssetManagemantNetRequest getInstance];
    }
    return self;
}

+ (instancetype)getInstance {
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[AssetManagementBusiness alloc] init];
        });
    }
    return instance;
}

//查询资产概况
- (void) getBaseInfoOfAsset:(RequestAssetBaseInfoParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            AssetBaseInfoResponse * response = [AssetBaseInfoResponse mj_objectWithKeyValues:responseObject];
            if (success) {
                success(BUSINESS_ASSET_BASE_INFO,response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_ASSET_BASE_INFO,error);
            }
        }];
    }
}

//获取设备详情
- (void) getEquipmentDetail:(AssetEquipmentDetailRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail{
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            AssetEquipmentResponse * response = [AssetEquipmentResponse mj_objectWithKeyValues:responseObject];
            if (success) {
                success(BUSINESS_ASSET_EQUIPMENT_DETAIL,response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_ASSET_EQUIPMENT_DETAIL,error);
            }
        }];
    }
}

//根据二维码扫描结果获取设备详情
- (void) getEquipmentDetailByQrCode:(AssetEquipmentDetailQrcodeRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            AssetEquipmentResponse * response = [AssetEquipmentResponse mj_objectWithKeyValues:responseObject];
            if (success) {
                success(BUSINESS_ASSET_EQUIPMENT_DETAIL,response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_ASSET_EQUIPMENT_DETAIL,error);
            }
        }];
    }
}

//查询设备绑定的合同
- (void) getEquipmentContract:(ContractQueryParam *)param Success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            ContractQueryResponse * response = [ContractQueryResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_ASSET_CONTRACT, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_ASSET_CONTRACT,error);
            }
        }];
    }
}

//查询工单列表
- (void) getAssetOrderRecord:(AssetWorkOrderQueryRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (param.type == ASSET_WORK_ORDER_RECORD_QUERY_FIXED) {
                AssetFixedRecordResponse * response = [AssetFixedRecordResponse mj_objectWithKeyValues:responseObject];
                if (success) {
                    success(BUSINESS_ASSET_EQUIPMENT_ORDER_RECORD,response.data);
                }
            } else if (param.type == ASSET_WORK_ORDER_RECORD_QUERY_MAINTAIN) {
                AssetMaintainRecordResponse * response = [AssetMaintainRecordResponse mj_objectWithKeyValues:responseObject];
                if (success) {
                    success(BUSINESS_ASSET_EQUIPMENT_ORDER_RECORD,response.data);
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_ASSET_EQUIPMENT_ORDER_RECORD,error);
            }
        }];
    }
}

//获取设备列表或者筛选设备
- (void) getEquipmentsListDataByParam:(AssetManagementEquipmentsRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            AssetManagementEquipmentsResponse * response =  [AssetManagementEquipmentsResponse mj_objectWithKeyValues:responseObject];
            if (success) {
                success(BUSINESS_ASSET_EQUIPMENT_LIST,response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_ASSET_EQUIPMENT_LIST,error);
            }
        }];
    }
}

//获取设备巡检记录
- (void) getEquipmentPatrolRecordByParam:(AssetPatrolRecordRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            AssetPatrolRecordResponse * response =  [AssetPatrolRecordResponse mj_objectWithKeyValues:responseObject];
            if (success) {
                success(BUSINESS_ASSET_EQUIPMENT_PATROL_RECORD,response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_ASSET_EQUIPMENT_PATROL_RECORD,error);
            }
        }];
    }
}

//获取核心组件详情
- (void) getCoreComponentDetailByParam:(AssetCoreComponentDetailRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            AssetCoreComponentDetailResponse * response =  [AssetCoreComponentDetailResponse mj_objectWithKeyValues:responseObject];
            if (success) {
                success(BUSINESS_ASSET_CORE_COMPONENT_DETAIL,response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_ASSET_CORE_COMPONENT_DETAIL,error);
            }
        }];
    }
}

//获取核心组件列表
- (void) getCoreComponentListByParam:(AssetCoreComponentListParam *) param Success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            AssetCoreComponentListResponse * response =  [AssetCoreComponentListResponse mj_objectWithKeyValues:responseObject];
            if (success) {
                success(BUSINESS_ASSET_CORE_COMPONENT_LIST,response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_ASSET_CORE_COMPONENT_LIST,error);
            }
        }];
    }
}

//获取待处理工单列表
- (void) getUndoWorkOrderListByParam:(AssetUndoWorkOrderRequestParam *)param Success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            AssetUndoWorkOrderResponse *response =  [AssetUndoWorkOrderResponse mj_objectWithKeyValues:responseObject];
            if (success) {
                success(BUSINESS_ASSET_UNDO_WORKORDER_LIST,response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_ASSET_UNDO_WORKORDER_LIST,error);
            }
        }];
    }
}

@end

