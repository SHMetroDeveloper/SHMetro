//
//  InventoryBusiness.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/12/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "BaseBusiness.h"
#import "ReserveInventoryEntity.h"
#import "ReservationEntity.h"
#import "ReservationDetailEntity.h"
#import "OperateReservationEntity.h"
#import "WarehouseEntity.h"
#import "MaterialEntity.h"
#import "InventoryMaterialDetailBatchEntity.h"
#import "InventoryMaterialDetailEntity.h"
#import "InventoryMaterialDetailRecordEntity.h"
#import "InventoryMaterialProviderEntity.h"
#import "InventoryMaterialStorageInEntity.h"
#import "InventoryMaterialQueryEntity.h"
#import "InventoryDeliveryEntity.h"
#import "InventoryWarehouseQueryEntity.h"
#import "InventoryMaterialCheckEntity.h"
#import "EditReservationHandlerEntity.h"

typedef NS_ENUM(NSInteger, InventoryBusinessType) {
    BUSINESS_INVENTORY_UNKNOW,   //
    BUSINESS_INVENTORY_GET_WAREHOUSES,       //获取仓库列表
    BUSINESS_INVENTORY_GET_MATERIALS,    //获取物料列表
    BUSINESS_INVENTORY_GET_MATERIAL_BATCHS,    //获取物料的批次列表
    BUSINESS_INVENTORY_GET_LIST,   //获取我的预定，待审核记录，我的审核记录
    BUSINESS_INVENTORY_GET_LIST_OF_WORK_ORDER,   //获取工单关联预订单
    BUSINESS_INVENTORY_GET_DETAIL,   //获取预定详情
    BUSINESS_INVENTORY_RESERVE,   //预定
    BUSINESS_INVENTORY_STORAGE_IN,   //入库
    BUSINESS_INVENTORY_STORAGE_CHECK,   //盘点
    BUSINESS_INVENTORY_STORAGE_MOVE,   //移库
    BUSINESS_INVENTORY_MATERIAL,   //物资详情
    BUSINESS_INVENTORY_MATERIAL_RECORD,   //物资详情记录
    BUSINESS_INVENTORY_PROVIDER,   //供应商列表
    BUSINESS_INVENTORY_WAREHOUSE,   //仓库列表
    BUSINESS_INVENTORY_MATERIAL_LIST,   //物资列表列表
    BUSINESS_INVENTORY_DELIVERY,   //出库
    BUSINESS_INVENTORY_CANCEL_DELIVERY,   //取消出库
    BUSINESS_INVENTORY_GET_MATERIAL_DETAIL,   //获取物料详情
    BUSINESS_INVENTORY_RESERVATION_APPROVAL,   //审批预订单
    BUSINESS_INVENTORY_RESERVATION_EDIT_HANDLER,   //修改预定单的操作人员（仓库管理员，主管等信息）
};


@interface InventoryBusiness : BaseBusiness

+ (instancetype) getInstance;

//获取仓库列表
- (void) getWarehouseList:(InventoryGetWarehouseParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//获取物料列表
- (void) getMaterialList:(InventoryGetMaterialParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//获取物料批次列表
- (void) getMaterialBatchList:(InventoryGetMaterialDetailBatchType) type material:(NSNumber *) inventoryId page:(NetPage *) page success:(business_success_block) success fail:(business_failure_block) fail;

//通过ID 获取物料详情
- (void) getMaterialDetailById:(NSNumber *) inventoryId success:(business_success_block) success fail:(business_failure_block) fail;

//通过编码 获取物料详情
- (void) getMaterialDetailByCode:(NSString *) code warehouse:(NSNumber *) warehouseId success:(business_success_block) success fail:(business_failure_block) fail;

//库存预定
- (void) requestReserve:(ReserveInventoryRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//获取库存预定列表
- (void) getReservationList:(GetReservationListParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//获取工单关联预订单列表
- (void) getReservationListOfWorkOrder:(NSNumber *) woId success:(business_success_block)success fail:(business_failure_block)fail;

//获取预定详情
- (void) getReservationDetail:(GetReservationDetailRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//入库
- (void) requestStorageInMaterial:(InventoryMaterialStorageInRequestParam *)param success:(business_success_block) success fail:(business_failure_block) fail;

//盘点
- (void) requestCheckInMaterial:(InventoryMaterialCheckRequestParam *)param success:(business_success_block) success fail:(business_failure_block) fail;

//移库
- (void) requestMoveMaterial:(InventoryMaterialStorageInRequestParam *)param success:(business_success_block) success fail:(business_failure_block) fail;

//获取物资详情
- (void) requestMaterialDetail:(InventoryMaterialDetailIdRequestParam *)param success:(business_success_block) success fail:(business_failure_block) fail;

//通过code获取物资详情
- (void) requestMaterialDetailByCode:(InventoryMaterialDetailCodeRequestParam *)param success:(business_success_block) success fail:(business_failure_block) fail;

//获取物资详情记录
- (void) requestMaterialDetailRecord:(InventoryMaterialDetailRecordRequestParam *)param success:(business_success_block) success fail:(business_failure_block) fail;

//获取供应商列表
- (void) requestMaterialProvider:(InventoryMaterialProviderRequestParam *)param success:(business_success_block) success fail:(business_failure_block) fail;

//出库
- (void) requestDelivery:(InventoryDeliveryParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//预定单审批
- (void) requestApprovalRerservation:(ReservationApprovalRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//查询仓库列表
- (void) requestWarehouseListBy:(NetPage *)netPage success:(business_success_block)success fail:(business_failure_block)fail;

//查询物资列表
- (void) requestMaterialListBy:(InventoryMaterialQueryRequestParam *)param success:(business_success_block)success fail:(business_failure_block)fail;

//修改预定单操作人
- (void) requestEditReservationHandler:(EditReservationHandlerParam *) param success:(business_success_block)success fail:(business_failure_block)fail;

//修改预定单操作人
- (void) requestEditReservationHandler:(EditReservationHandlerParam *) param success:(business_success_block)success fail:(business_failure_block)fail;
@end
