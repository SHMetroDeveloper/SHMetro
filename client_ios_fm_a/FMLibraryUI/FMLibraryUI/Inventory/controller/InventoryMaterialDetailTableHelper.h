//
//  InventoryMaterialDetailTableHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/29/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryMaterialDetailEntity.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, InventoryMaterialDetailEventType) {
    INVENTORY_MATERIAL_DETAIL_EVENT_UNKNOW,
    INVENTORY_MATERIAL_DETAIL_EVENT_EDIT_AMOUNT,   //修改批次出库数量
    INVENTORY_MATERIAL_DETAIL_EVENT_NEED_UPDATE,   //列表需要刷新
    INVENTORY_MATERIAL_DETAIL_EVENT_SELECT_WAREHOUSE_TARGET,   //选择目标仓库
    INVENTORY_MATERIAL_DETAIL_EVENT_SELECT_ADMINISTRATOR_SRC,   //选择原仓库管理员
    INVENTORY_MATERIAL_DETAIL_EVENT_SELECT_ADMINISTRATOR_TARGET, //选择目标仓库管理员
    INVENTORY_MATERIAL_DETAIL_EVENT_SELECT_SUPERVISOR,   //选择主管
    INVENTORY_MATERIAL_DETAIL_EVENT_SELECT_RECIVING_PERSON,  //选择领用人
};

typedef NS_ENUM(NSInteger, InventoryMaterialTableViewType) {
    INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_UNKNOW,
    INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_DELIVERY_NORMAL,   //正常出库样式
    INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_DELIVERY_QRCODE,   //二维码出库样式
    INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_RESERVATION,  //预定物料
    INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_SHIFT_NORMAL,   //正常移库样式
    INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_SHIFT_QRCODE,   //二维码移库样式
    
};

@interface InventoryMaterialDetailTableHelper : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype) init;

//设置tableview主要样式
- (void) setInventoryMaterialTableViewType:(InventoryMaterialTableViewType) type;

//设置物料详情
- (void) setInfoWithMaterialDetail:(InventoryMaterialDetail *) material;

//设置批次
- (void) setInfoWithBatchArray:(NSMutableArray *) array;

//添加批次
- (void) addBatchArray:(NSMutableArray *) array;

//设置预定数量
- (void) setReservedAmount:(NSNumber *) amount;

//设置批次的出库数量
- (void) setAmount:(NSNumber *) amount forBatch:(NSNumber *) batchId;


//设置源仓库名及目标仓库名
- (void) setSrcWarehouse:(NSString *) srcName targetWarehouse:(NSString *) targetName;

//设置源仓库管理员，及目标仓库管理员
- (void) setSrcAdministrator:(NSString *)srcAdministrator andTargetAdministrator:(NSString *)targetAdministrator;

//设置主管及领用人
- (void) setSupervisor:(NSString *)supervisor;

- (void) setReceivingPerson:(NSString *)receivingPerson;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end

