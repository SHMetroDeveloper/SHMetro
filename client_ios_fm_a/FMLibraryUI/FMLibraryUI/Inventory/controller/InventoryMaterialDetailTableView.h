//
//  InventoryMaterialDetailTableView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/30.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMLoadMoreFooterView.h"
#import "InventoryMaterialDetailEntity.h"
#import "InventoryMaterialDetailRecordEntity.h"

typedef NS_ENUM(NSInteger, ItemTypeClick) {
    MATERIAL_TYPE_CLICK_PHOTO = 100,
    MATERIAL_TYPE_CLICK_ATTACHMENT = 200
};

typedef void(^MaterialDetailLoadMoreActionBlock)();
typedef void(^ImageAndAttachmentActionBlock)(ItemTypeClick type, id object);

@interface InventoryMaterialDetailTableView : UITableView

@property (nonatomic, copy) MaterialDetailLoadMoreActionBlock loadMoreBlock;
@property (nonatomic, copy) ImageAndAttachmentActionBlock itemClickBlock;

@property (nonatomic, strong) InventoryMaterialDetail *materialDetail;

@property (nonatomic, strong) NSMutableArray<InventoryMaterialDetailRecordDetail *> *recordArray;

@end
