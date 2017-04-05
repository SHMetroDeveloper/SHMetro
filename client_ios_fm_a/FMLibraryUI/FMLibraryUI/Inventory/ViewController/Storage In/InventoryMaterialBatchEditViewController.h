//
//  MaterialBatchEditViewController.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/29.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"
#import "InventoryMaterialStorageInEntity.h"
#import "InventoryMaterialBatchViewModel.h"

typedef NS_ENUM(NSInteger, BatchEditType) {
    BATCH_EDIT_TYPE_ADD = 100,
    BATCH_EDIT_TYPE_MODIFY = 200
};

@interface InventoryMaterialBatchEditViewController : BaseViewController

@property (nonatomic, strong) NSNumber *inventoryId;

@property (nonatomic, assign) BatchEditType editType;

- (void)setMaterialBatchModelToModify:(InventoryMaterialBatchViewModel *) modifyMaterialBatchModel;

- (void)setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
