//
//  InventoryStorageInAddMaterialViewController.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/28.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"
#import "InventoryMaterialStorageInEntity.h"
#import "InventoryMaterialBatchViewModel.h"

typedef NS_ENUM(NSInteger, InventoryStorageInMaterialDetailEventType) {
    INVENTORY_STORAGE_IN_MATERIAL_DETAIL_EVENT_UNKNOW,
    INVENTORY_STORAGE_IN_MATERIAL_DETAIL_EVENT_OK,    //批次修改确定
    INVENTORY_STORAGE_IN_MATERIAL_QRCODE_OK,    //通过扫描选择完成
};

typedef NS_ENUM(NSInteger, InventoryStorageInOperateType) {
    INVENTORY_STORAGE_IN_NORMAL,
    INVENTORY_STORAGE_IN_QR_SCAN
};

@interface InventoryStorageInEditMaterialViewController : BaseViewController

//通过inventoryId进入
@property (nonatomic, strong) __block NSNumber *inventoryId;

//入库操作类型
@property (nonatomic, assign) InventoryStorageInOperateType operateType;

//通过扫描二维码进入
@property (nonatomic, assign) BOOL fromQrcode;
@property (nonatomic, strong) __block NSString * materialCode;
@property (nonatomic, strong) __block NSNumber * warehouseId;

@property (nonatomic, strong) NSMutableArray<InventoryMaterialBatchViewModel *> *batchModelArray;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
