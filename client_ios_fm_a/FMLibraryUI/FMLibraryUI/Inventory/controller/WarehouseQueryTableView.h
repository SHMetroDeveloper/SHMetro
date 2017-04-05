//
//  InventoryHistoryTableView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/5.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryWarehouseQueryEntity.h"
#import "FMLoadMoreFooterView.h"
#import "FMRefreshHeaderView.h"
#import "MJRefreshNormalHeader.h"

typedef NS_ENUM(NSInteger,WarehouseRefreshType) {
    WAREHOUSE_REFRESH_TYPE_REFRESH,
    WAREHOUSE_REFRESH_TYPE_LOADMORE
};

typedef void(^WarehouseSelectActionBlock)(NSNumber *warehouseId, NSString *warehouseName);
typedef void(^WarehouseRefreshActionBlock)(WarehouseRefreshType type);

@interface WarehouseQueryTableView : UITableView

@property (nonatomic, strong) NSMutableArray<InventoryWarehouseDetail *> *dataArray;

@property (nonatomic, copy) WarehouseRefreshActionBlock refreshBlock;
@property (nonatomic, copy) WarehouseSelectActionBlock actionBlock;

@end
