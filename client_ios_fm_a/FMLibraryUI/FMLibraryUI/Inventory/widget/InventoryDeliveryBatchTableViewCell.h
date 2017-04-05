//
//  InventoryDeliveryBatchTableViewCell.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/29/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryMaterialDetailBatchEntity.h"

typedef NS_ENUM(NSInteger, InventoryDeliveryBatchTableViewCellType) {
    INVENTORTY_BATCH_TABLE_VIEW_CELL_TYPE_DELIVERY,
    INVENTORTY_BATCH_TABLE_VIEW_CELL_TYPE_SHIFT
};

@interface InventoryDeliveryBatchTableViewCell : UITableViewCell

//设置物料信息
- (void) setInfoWithBatch:(InventoryMaterialDetailBatchEntity *) batch;

//设置出库数量
- (void) setInfoWithOutNumber:(NSNumber *) outNumber;

//设置物料和数量信息
- (void) setInfoWithBatch:(InventoryMaterialDetailBatchEntity *)batch outNumber:(NSNumber *)outNumber;

//设置底部分割线的显示
- (void) setShowFullSeperator:(BOOL)showFullSeperator;

//设置批次操作数量种类
- (void) setAmountType:(InventoryDeliveryBatchTableViewCellType) amountType;

//计算所需要的高度
+ (CGFloat) calculateHeight;

@end
