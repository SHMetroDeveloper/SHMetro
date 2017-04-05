//
//  InventoryMaterialCountEditTableView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/1.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMLoadMoreFooterView.h"
#import "InventoryMaterialDetailEntity.h"
#import "InventoryBatchCheckViewModel.h"

typedef NS_ENUM(NSInteger, MATERIAL_COUNT_EDIT_TYPE) {
    MATERIAL_COUNT_EDIT_TYPE_EXPAND,
    MATERIAL_COUNT_EDIT_TYPE_COUNT
};

typedef NS_ENUM(NSInteger, ItemTypeClick) {
    MATERIAL_TYPE_CLICK_PHOTO = 100,
    MATERIAL_TYPE_CLICK_ATTACHMENT = 200
};

typedef void(^ImageAndAttachmentActionBlock)(ItemTypeClick type, id object);
typedef void(^MaterialEditActionBlock)(MATERIAL_COUNT_EDIT_TYPE type, id eventData);
typedef void(^RecordLoadMoreActionBlock)();

@interface InventoryMaterialCheckEditTableView : UITableView

@property (nonatomic, strong) InventoryMaterialDetail *materialDetail;

@property (nonatomic, strong) NSMutableArray<InventoryBatchCheckViewModel *> *batchArray;

@property (nonatomic, copy) MaterialEditActionBlock actionBlock;
@property (nonatomic, copy) RecordLoadMoreActionBlock loadMoreBlock;
@property (nonatomic, copy) ImageAndAttachmentActionBlock itemClickBlock;

@end
