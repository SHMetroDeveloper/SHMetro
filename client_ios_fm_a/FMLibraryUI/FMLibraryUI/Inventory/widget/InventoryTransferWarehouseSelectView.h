//
//  InventoryTransferWarehouseSelectView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/5/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, InventoryTransferWarehouseSelectType) {
    INVENTORY_TRANSFER_WAREHOUSE_SELECT_UNKNOW,
    INVENTORY_TRANSFER_WAREHOUSE_SELECT_SRC,    //选择源仓库
    INVENTORY_TRANSFER_WAREHOUSE_SELECT_TARGET, //选择目标仓库
};

@interface InventoryTransferWarehouseSelectView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithSrcWarehouse:(NSString *) srcName targetWarehouse:(NSString *) targetName;

- (void) setShowBottomSeperator:(BOOL) show;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;
@end
