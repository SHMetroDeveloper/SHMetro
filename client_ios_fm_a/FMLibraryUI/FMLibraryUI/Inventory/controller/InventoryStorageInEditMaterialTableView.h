//
//  InventoryStorageInEditMaterialTableView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/28.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryMaterialDetailEntity.h"
#import "InventoryMaterialBatchViewModel.h"

typedef NS_ENUM(NSInteger, MATERIAL_EDIT_TYPE) {
    MATERIAL_EDIT_TYPE_EXPAND,
    MATERIAL_EDIT_TYPE_BATCH_ADD,
    MATERIAL_EDIT_TYPE_BATCH_EDIT,
    MATERIAL_EDIT_TYPE_BATCH_DELETE
};

typedef NS_ENUM(NSInteger, ItemTypeClick) {
    MATERIAL_TYPE_CLICK_PHOTO = 100,
    MATERIAL_TYPE_CLICK_ATTACHMENT = 200
};

typedef void(^MaterialEditActionBlock)(MATERIAL_EDIT_TYPE type, id eventData);
typedef void(^ImageAndAttachmentActionBlock)(ItemTypeClick type, id object);

@interface InventoryStorageInEditMaterialTableView : UITableView

@property (nonatomic, strong) InventoryMaterialDetail *materialDetail;

@property (nonatomic, strong) NSMutableArray<InventoryMaterialBatchViewModel *> *batchArray;

@property (nonatomic, copy) MaterialEditActionBlock actionBlock;
@property (nonatomic, copy) ImageAndAttachmentActionBlock itemClickBlock;

@end
