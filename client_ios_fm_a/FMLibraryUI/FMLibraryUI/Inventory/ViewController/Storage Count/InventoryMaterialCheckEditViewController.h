//
//  InventoryMaterialCountEditViewController.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/1.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "BaseViewController.h"
#import "OnMessageHandleListener.h"
#import "InventoryBatchCheckViewModel.h"

typedef NS_ENUM(NSInteger, InventoryCheckMaterialDetailEventType) {
    INVENTORY_CHECK_MATERIAL_DETAIL_EVENT_UNKNOW,
    INVENTORY_CHECK_MATERIAL_DETAIL_EVENT_OK,    //批次修改确定
    INVENTORY_CHECK_MATERIAL_QRCODE_OK,    //通过扫描选择完成
};

typedef NS_ENUM(NSInteger, InventoryCheckOperateType) {
    INVENTORY_CHECK_NORMAL,
    INVENTORY_CHECK_SCAN
};

@interface InventoryMaterialCheckEditViewController : BaseViewController

//通过inventoryId进入
@property (nonatomic, strong) NSNumber *inventoryId;

//盘点操作类型
@property (nonatomic, assign) InventoryCheckOperateType operateType;

//通过扫描二维码进入
@property (nonatomic, assign) BOOL fromQrcode; //来自二维码扫描
@property (nonatomic, strong) NSString * materialCode;  //物料编码
@property (nonatomic, strong) NSNumber * warehouseId;  //仓库ID

@property (nonatomic, strong) NSMutableArray<InventoryBatchCheckViewModel *> *editBatchModelArray;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;
@end
