//
//  InventoryMaterialCheckEntity.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/8.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import <UIKit/UIKit.h>

@interface InventoryMaterialCheckBatch : NSObject
@property (nonatomic, strong) NSNumber *batchId;   //批次ID
@property (nonatomic, strong) NSString * inventoryNumber;   //库存量
@property (nonatomic, strong) NSString * number;  //清点数量
@end

@interface InventoryMaterialCheckInventory : NSObject
@property (nonatomic, strong) NSNumber *inventoryId;
@property (nonatomic, strong) NSMutableArray<InventoryMaterialCheckBatch *> *batch;
@end

@interface InventoryMaterialCheckRequestParam : BaseRequest
@property (nonatomic, strong) NSNumber *warehouseId;  //仓库id
@property (nonatomic, strong) NSMutableArray<InventoryMaterialCheckInventory *> *inventory;
- (NSString *)getUrl;
@end

