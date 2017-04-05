//
//  InventoryDeliveryMaterialTableViewCell.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaterialEntity.h"

//类型
typedef NS_ENUM(NSInteger, InventoryMaterialType) {
    INVENTORY_MATERIAL_IN_CELL, //入库 Cell
    INVENTORY_MATERIAL_OUT_CELL, //出库 Cell
    INVENTORY_MATERIAL_MOVE_CELL, //移库 Cell
    INVENTORY_MATERIAL_RESERVE_CELL, //预定 Cell
};

@interface InventoryMaterialTableViewCell : UITableViewCell

//设置 Cell Type
- (void) setType:(InventoryMaterialType) type;

//设置物料信息
- (void) setInfoWithMaterial:(MaterialEntity *) material;

//设置数量
- (void) setInfoWithAmount:(NSNumber *) amount;

//设置物料和数量信息
- (void) setInfoWithMaterial:(MaterialEntity *) material amount:(NSNumber *) amount;

//设置底部分割线的显示
- (void) setShowFullSeperator:(BOOL)showFullSeperator;

//计算所需要的高度
+ (CGFloat) calculateHeight;
@end
