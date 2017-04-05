//
//  InventoryDeliveryMaterialDetailViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/29/16.
//  Copyright © 2016 facilityone. All rights reserved.
//
//  出库物资调整界面

#import "BaseViewController.h"
#import "MaterialEntity.h"
#import "ReservationDetailEntity.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, InventoryDeliveryOperationType) {
    INVENTORY_DELIVERY_MATERIAL_TYPE_UNKNOW,
    INVENTORY_DELIVERY_MATERIAL_TYPE_DELIVERY_NORMAL,  //直接出库
    INVENTORY_DELIVERY_MATERIAL_TYPE_DELIVERY_QRCODE,  //扫描二维码出库
    INVENTORY_DELIVERY_MATERIAL_TYPE_RESERVATION,  //预定物料
    INVENTORY_DELIVERY_MATERIAL_TYPE_SHIFT_NORMAL,  //直接移库
    INVENTORY_DELIVERY_MATERIAL_TYPE_SHIFT_QRCODE,  //扫描二维码移库
};

typedef NS_ENUM(NSInteger, InventoryDeliveryMaterialDetailEventType) {
    INVENTORY_DELIVERY_MATERIAL_DETAIL_EVENT_UNKNOW,
    INVENTORY_DELIVERY_MATERIAL_DETAIL_EVENT_OK,    //批次修改确定
    INVENTORY_DELIVERY_MATERIAL_QRCODE_OK,    //通过扫描选择完成
};


@interface InventoryDeliveryMaterialDetailViewController : BaseViewController

- (instancetype) init;

//设置操作类型（会影响展示的信息描述）
- (void) setOperationType:(InventoryDeliveryOperationType) operationType;

//设置只读
- (void) setReadOnly:(BOOL)readOnly;

//直接出库使用
- (void) setInfoWithMaterial:(MaterialEntity *) material batch:(NSMutableArray *) array;

//预定出库使用
- (void) setInfoWithReservationMaterial:(ReservationMaterial *) material batch:(NSMutableArray *) array;

//预定出库批次价格  batchId : "batchPrice"
- (void) setInfoWithRealCost:(NSMutableDictionary *)costDict;

//预定出库批次数量  batchId : "batchNumber"
- (void) setInfoWithBatchNumber:(NSMutableDictionary *)numberDict;

//二维码扫描时使用
- (void) setInfoWithMaterialCode:(NSString *) materialCode warehouseId:(NSNumber *) warehouseId;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end

