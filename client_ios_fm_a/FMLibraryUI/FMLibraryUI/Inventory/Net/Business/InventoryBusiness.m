//
//  InventoryBusiness.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/12/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "InventoryBusiness.h"
#import "InventoryNetRequest.h"
#import "MJExtension.h"
#import "InventoryMaterialDetailEntity.h"

InventoryBusiness * inventoryInstance;

@interface InventoryBusiness ()

@property (readwrite, nonatomic, strong) InventoryNetRequest * netRequest;

@end

@implementation InventoryBusiness

+ (instancetype) getInstance {
    if(!inventoryInstance) {
        inventoryInstance = [[InventoryBusiness alloc] init];
    }
    return inventoryInstance;
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _netRequest = [InventoryNetRequest getInstance];
    }
    return self;
}

//获取仓库列表
- (void) getWarehouseList:(InventoryGetWarehouseParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                InventoryGetWarehouseResponse * response = [InventoryGetWarehouseResponse mj_objectWithKeyValues:responseObject];
                success(BUSINESS_INVENTORY_GET_WAREHOUSES, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_INVENTORY_GET_WAREHOUSES, error);
            }
        }];
    }
}

//获取物料列表
- (void) getMaterialList:(InventoryGetMaterialParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                InventoryGetMaterialResponse * response = [InventoryGetMaterialResponse mj_objectWithKeyValues:responseObject];
                success(BUSINESS_INVENTORY_GET_MATERIALS, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_INVENTORY_GET_MATERIALS, error);
            }
        }];
    }
}

//获取物料批次列表
- (void) getMaterialBatchList:(InventoryGetMaterialDetailBatchType) type material:(NSNumber *) inventoryId page:(NetPage *) page success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest && inventoryId) {
        InventoryGetMaterialDetailBatchParam * param = [[InventoryGetMaterialDetailBatchParam alloc] init];
        param.inventoryId = inventoryId;
        param.type = type;
        param.page.pageNumber = [page.pageNumber copy];
        param.page.pageSize = [page.pageSize copy];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                InventoryGetMaterialDetailBatchResponse * resonse = [InventoryGetMaterialDetailBatchResponse mj_objectWithKeyValues:responseObject];
                success(BUSINESS_INVENTORY_GET_MATERIAL_BATCHS, resonse.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_INVENTORY_GET_MATERIAL_BATCHS, error);
            }
        }];
    }
}

//通过ID 获取物料详情
- (void) getMaterialDetailById:(NSNumber *) inventoryId success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest && inventoryId) {
        InventoryMaterialDetailIdRequestParam * param = [[InventoryMaterialDetailIdRequestParam alloc] init];
        param.inventoryId = inventoryId;
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                InventoryMaterialDetailResponse * resonse = [InventoryMaterialDetailResponse mj_objectWithKeyValues:responseObject];
                success(BUSINESS_INVENTORY_GET_MATERIAL_DETAIL, resonse.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_INVENTORY_GET_MATERIAL_DETAIL, error);
            }
        }];
    }
    
    
}

//通过编码 获取物料详情
- (void) getMaterialDetailByCode:(NSString *) code warehouse:(NSNumber *) warehouseId success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest && code) {
        InventoryMaterialDetailCodeRequestParam * param = [[InventoryMaterialDetailCodeRequestParam alloc] init];
        param.code = code;
        param.warehouseId = warehouseId;
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                InventoryMaterialDetailResponse * resonse = [InventoryMaterialDetailResponse mj_objectWithKeyValues:responseObject];
                success(BUSINESS_INVENTORY_GET_MATERIAL_DETAIL, resonse.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_INVENTORY_GET_MATERIAL_DETAIL, error);
            }
        }];
    }
}

//库存预定
- (void) requestReserve:(ReserveInventoryRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_INVENTORY_RESERVE, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_INVENTORY_RESERVE, error);
            }
        }];
    }
}

//获取库存预定列表
- (void) getReservationList:(GetReservationListParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                GetReservationListResponse * response = [GetReservationListResponse mj_objectWithKeyValues:responseObject];
                success(BUSINESS_INVENTORY_GET_LIST, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_INVENTORY_GET_LIST, error);
            }
        }];
    }
}

//获取工单关联预订单列表
- (void) getReservationListOfWorkOrder:(NSNumber *) woId success:(business_success_block)success fail:(business_failure_block)fail {
    if (_netRequest) {
        GetReservationListOfWorkOrderParam * param = [[GetReservationListOfWorkOrderParam alloc] init];
        param.woId = woId;
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                GetReservationListOfWorkOrderResponse * response = [GetReservationListOfWorkOrderResponse mj_objectWithKeyValues:responseObject];
                success(BUSINESS_INVENTORY_GET_LIST_OF_WORK_ORDER, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_INVENTORY_GET_LIST_OF_WORK_ORDER, error);
            }
        }];
    }
}

//获取预定详情
- (void) getReservationDetail:(GetReservationDetailRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                GetReservationDetailResponse * response = [GetReservationDetailResponse mj_objectWithKeyValues:responseObject];
                success(BUSINESS_INVENTORY_GET_DETAIL, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_INVENTORY_GET_DETAIL, error);
            }
        }];
    }
}

//入库
- (void) requestStorageInMaterial:(InventoryMaterialStorageInRequestParam *)param success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_INVENTORY_STORAGE_IN, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_INVENTORY_STORAGE_IN, error);
            }
        }];
    }
}

//盘点
- (void) requestCheckInMaterial:(InventoryMaterialCheckRequestParam *)param success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_INVENTORY_STORAGE_CHECK, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_INVENTORY_STORAGE_CHECK, error);
            }
        }];
    }
}

//移库
- (void) requestMoveMaterial:(InventoryMaterialStorageInRequestParam *)param success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_INVENTORY_STORAGE_MOVE, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_INVENTORY_STORAGE_MOVE, error);
            }
        }];
    }
}


//获取物资详情
- (void) requestMaterialDetail:(InventoryMaterialDetailIdRequestParam *)param success:(business_success_block) success fail:(business_failure_block) fail {
    [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        InventoryMaterialDetailResponse *response = [InventoryMaterialDetailResponse mj_objectWithKeyValues:responseObject];
        if(success) {
            success(BUSINESS_INVENTORY_MATERIAL, response.data);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(fail) {
            fail(BUSINESS_INVENTORY_MATERIAL, error);
        }
    }];
}

//通过code获取物资详情
- (void) requestMaterialDetailByCode:(InventoryMaterialDetailCodeRequestParam *)param success:(business_success_block) success fail:(business_failure_block) fail{
    [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        InventoryMaterialDetailResponse *response = [InventoryMaterialDetailResponse mj_objectWithKeyValues:responseObject];
        if(success) {
            success(BUSINESS_INVENTORY_MATERIAL, response.data);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(fail) {
            fail(BUSINESS_INVENTORY_MATERIAL, error);
        }
    }];
}


//获取物资详情记录
- (void) requestMaterialDetailRecord:(InventoryMaterialDetailRecordRequestParam *)param success:(business_success_block) success fail:(business_failure_block) fail {
    [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        InventoryMaterialDetailRecordResponse *response = [InventoryMaterialDetailRecordResponse mj_objectWithKeyValues:responseObject];
        if(success) {
            success(BUSINESS_INVENTORY_MATERIAL_RECORD, response.data);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(fail) {
            fail(BUSINESS_INVENTORY_MATERIAL_RECORD, error);
        }
    }];
}


//获取供应商列表
- (void) requestMaterialProvider:(InventoryMaterialProviderRequestParam *)param success:(business_success_block) success fail:(business_failure_block) fail{
    [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        InventoryMaterialProviderResponse *response = [InventoryMaterialProviderResponse mj_objectWithKeyValues:responseObject];
        if(success) {
            success(BUSINESS_INVENTORY_PROVIDER, response.data);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(fail) {
            fail(BUSINESS_INVENTORY_PROVIDER, error);
        }
    }];
}


//出库
- (void) requestDelivery:(InventoryDeliveryParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_INVENTORY_DELIVERY, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_INVENTORY_DELIVERY, error);
            }
        }];
    }
}

//预定单审批
- (void) requestApprovalRerservation:(ReservationApprovalRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_INVENTORY_RESERVATION_APPROVAL, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_INVENTORY_RESERVATION_APPROVAL, error);
            }
        }];
    }
}

//查询仓库列表
- (void) requestWarehouseListBy:(NetPage *)netPage success:(business_success_block)success fail:(business_failure_block)fail {
    if (_netRequest) {
        InventoryWarehouseQueryRequestParam *param = [[InventoryWarehouseQueryRequestParam alloc] initWithPageNumber:netPage.pageNumber andPageSize:netPage.pageSize];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            InventoryWarehouseQueryResponse *response = [InventoryWarehouseQueryResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_INVENTORY_WAREHOUSE, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_INVENTORY_WAREHOUSE, error);
            }
        }];
    }
}

//查询物资列表
- (void) requestMaterialListBy:(InventoryMaterialQueryRequestParam *)param success:(business_success_block)success fail:(business_failure_block)fail{
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            InventoryMaterialQueryResponse *response = [InventoryMaterialQueryResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_INVENTORY_MATERIAL_LIST, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_INVENTORY_MATERIAL_LIST, error);
            }
        }];
    }
}

//修改预定单操作人
- (void) requestEditReservationHandler:(EditReservationHandlerParam *) param success:(business_success_block)success fail:(business_failure_block)fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_INVENTORY_RESERVATION_EDIT_HANDLER, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_INVENTORY_RESERVATION_EDIT_HANDLER, error);
            }
        }];
    }
}

@end
