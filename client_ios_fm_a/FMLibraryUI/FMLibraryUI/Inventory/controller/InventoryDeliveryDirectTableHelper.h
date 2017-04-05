//
//  InventoryStorageOutTableHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/25/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"
#import "MaterialEntity.h"

typedef NS_ENUM(NSInteger, InventoryDeliveryTableEventType) {
    INVENTORY_DELIVERY_TABLE_EVENT_UNKNOW,
    INVENTORY_DELIVERY_TABLE_EVENT_SELECT_WAREHOUSE, //选择仓库
    INVENTORY_DELIVERY_TABLE_EVENT_SELECT_ADMINISTRATOR, //选择仓库管理员
    INVENTORY_DELIVERY_TABLE_EVENT_SELECT_SUPERVISOR, //选择主管
    INVENTORY_DELIVERY_TABLE_EVENT_SELECT_RECEIVING_PERSON, //选择领用人
    
    INVENTORY_DELIVERY_TABLE_EVENT_SHOW_MATERIAL,   //查看物料详情
    INVENTORY_DELIVERY_TABLE_EVENT_DELETE_MATERIAL, //删除物料
    
    
};

@interface InventoryDeliveryDirectTableHelper : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype) init;

//设置仓库信息
- (void) setInfoWithWarehouseName:(NSString *) warehouse;

//设置仓库管理员
- (void) setInfoWithAdministrator:(NSString *) administrator;

//设置主管
- (void) setInfoWithSupervisor:(NSString *) supervisor;

//设置领用人
- (void) setInfoWithReceivingPerson:(NSString *) person;

//设置物料数组
- (void) setInfoWithMaterials:(NSMutableArray *) array;

//添加物料
- (void) addMaterial:(MaterialEntity *) material;

//添加物料, 及出库量
- (void) addMaterial:(MaterialEntity *) material amount:(CGFloat) amount;

//设置物料的出库量
- (void) setAmount:(NSNumber *) amount forMaterial:(NSNumber *) inventoryId;

//删除物料
- (void) deleteMaterial:(MaterialEntity *) material;

//删除物料
- (void) deleteMaterialAtPosition:(NSInteger) position;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
