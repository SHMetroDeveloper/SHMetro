//
//  InventoryTransferTableHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/6/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"
#import "MaterialEntity.h"

typedef NS_ENUM(NSInteger, InventoryTransferTableEventType) {
    INVENTORY_TRANSFER_TABLE_EVENT_UNKNOW,
    INVENTORY_TRANSFER_TABLE_EVENT_SHOW_MATERIAL,   //查看物料详情
    INVENTORY_TRANSFER_TABLE_EVENT_DELETE_MATERIAL, //删除物料
    INVENTORY_TRANSFER_TABLE_EVENT_SELECT_ADMINISTRATOR_SRC,   //选择原仓库管理员
    INVENTORY_TRANSFER_TABLE_EVENT_SELECT_ADMINISTRATOR_TARGET,   //选择目标仓库管理员
};


@interface InventoryTransferTableHelper : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype) init;

//设置物料数组
- (void) setInfoWithMaterials:(NSMutableArray *) array;

//添加物料
- (void) addMaterial:(MaterialEntity *) material;

//添加物料, 及出库量
- (void) addMaterial:(MaterialEntity *) material amount:(CGFloat) amount;

//设置物料的出库量
- (void) setAmount:(NSNumber *) amount forMaterial:(NSNumber *) inventoryId;

//设置源仓库管理员
- (void) setSrcAdministrator:(NSString *)srcAdministrator;

//设置目标仓库管理员
- (void) setTargetAdministrator:(NSString *)targetAdministrator;

//删除物料
- (void) deleteMaterial:(MaterialEntity *) material;

//删除物料
- (void) deleteMaterialAtPosition:(NSInteger) position;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end

