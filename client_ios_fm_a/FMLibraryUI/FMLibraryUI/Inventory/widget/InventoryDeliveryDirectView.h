//
//  InventoryDeliveryDirectView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/25/16.
//  Copyright © 2016 facilityone. All rights reserved.
//
//  直接出库

#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"
#import "MaterialEntity.h"

typedef NS_ENUM(NSInteger, InventoryDeliveryDirectEventType) {
    INVENTORY_DELIVERY_EVENT_UNKNOW,
    INVENTORY_DELIVERY_EVENT_SELECT_WAREHOUSE,  //选择仓库
    INVENTORY_DELIVERY_EVENT_SELECT_ADMINISTRATOR,  //选择仓库管理员
    INVENTORY_DELIVERY_EVENT_SELECT_SUPERVISOR,  //选择主管
    INVENTORY_DELIVERY_EVENT_SELECT_RECEIVING_PERSON,  //选择领用人
    INVENTORY_DELIVERY_EVENT_SHOW_MATERIAL,     //显示物料详情
    INVENTORY_DELIVERY_EVENT_DELETE_MATERIAL,     //删除物料
//    INVENTORY_DELIVERY_EVENT_ADD_MATERIAL,     //添加物料
    INVENTORY_DELIVERY_EVENT_DELIVERY,     //出库
};

@interface InventoryDeliveryDirectView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithWarehouse:(NSString *) warehouse;

- (void) setInfoWithAdministrator:(NSString *) administrator;

- (void) setInfoWithSupervisor:(NSString *) supervisor;

- (void) setInfoWithReceivingPerson:(NSString *) person;


//设置物料数组
- (void) setInfoWithMaterials:(NSMutableArray *) materials;

//添加物料
- (void) addMaterial:(MaterialEntity *) material;

//设置物料的出库量
- (void) setAmount:(NSNumber *) amount forMaterial:(NSNumber *) inventoryId;

//删除物料
- (void) deleteMaterialAtPosition:(NSInteger) position;

//更新信息
- (void) updateList;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
