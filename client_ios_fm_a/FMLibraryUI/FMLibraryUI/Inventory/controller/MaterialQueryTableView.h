//
//  MaterialQueryTableView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/6.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryMaterialQueryEntity.h"
#import "FMLoadMoreFooterView.h"
#import "FMRefreshHeaderView.h"
#import "MJRefreshNormalHeader.h"

typedef NS_ENUM(NSInteger,MaterialRefreshType) {
    MATERIAL_REFRESH_TYPE_REFRESH,
    MATERIAL_REFRESH_TYPE_LOADMORE
};

typedef void(^MaterialSelectActionBlock)(NSNumber *inventoryId);
typedef void(^MaterialRefreshActionBlock)(MaterialRefreshType type);

@interface MaterialQueryTableView : UITableView

@property (nonatomic, strong) NSString *warehouseName;
@property (nonatomic, strong) NSMutableArray<InventoryMaterialQueryDetail *> *dataArray;

@property (nonatomic, copy) MaterialSelectActionBlock actionBlock;
@property (nonatomic, copy) MaterialRefreshActionBlock refreshBlock;

@end
