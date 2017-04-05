//
//  InventoryDeliveryEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//
//  出库

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import <UIKit/UIKit.h>

//出库类型
typedef NS_ENUM(NSInteger, InventoryDeliveryType) {
    INVENTORY_DELIVERY_TYPE_DIRECT,     //直接出库
    INVENTORY_DELIVERY_TYPE_RESERVED,   //预定出库
    INVENTORY_DELIVERY_TYPE_TRANSFER,   //移库出库
};

@interface InventoryDeliveryMaterialBatchEntity : NSObject
@property (readwrite, nonatomic, strong) NSNumber *batchId;
@property (readwrite, nonatomic, strong) NSString *amount;
- (instancetype) copy;
@end

@interface InventoryDeliveryMaterialEntity : NSObject
@property (readwrite, nonatomic, strong) NSNumber * inventoryId;
@property (readwrite, nonatomic, strong) NSMutableArray * batch;
@end

@interface InventoryDeliveryParam : BaseRequest
@property (readwrite, nonatomic, assign) InventoryDeliveryType type;
@property (readwrite, nonatomic, strong) NSNumber * activityId;
@property (readwrite, nonatomic, strong) NSNumber * warehouseId;
@property (readwrite, nonatomic, strong) NSNumber * targetWarehouseId;
@property (readwrite, nonatomic, strong) NSNumber * receivingPersonId;  //领用人
@property (readwrite, nonatomic, strong) NSNumber * administrator;      //仓库管理员
@property (readwrite, nonatomic, strong) NSNumber * targetAdministrator;//目标仓库管理员
@property (readwrite, nonatomic, strong) NSNumber * supervisor;         //主管
@property (readwrite, nonatomic, strong) NSMutableArray * inventory;
@end


