//
//  InventoryMaterialStorageInEntity.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/28.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import <UIKit/UIKit.h>


@interface InventoryMaterialStorageInBatch : NSObject
@property (nonatomic, strong) NSNumber *providerId;   //供应商ID
@property (nonatomic, strong) NSString *providerName;   //供应商名字
@property (nonatomic, strong) NSNumber *dueDate;   //过期时间
@property (nonatomic, strong) NSString *price;  //单价
@property (nonatomic, strong) NSString *number;  //入库数量
@end

@interface InventoryMaterialStorageInInventory : NSObject
@property (nonatomic, strong) NSNumber *inventoryId;
@property (nonatomic, strong) NSMutableArray *batch;
@end

@interface InventoryMaterialStorageInRequestParam : BaseRequest
@property (nonatomic, strong) NSNumber *warehouseId;   //仓库ID
@property (nonatomic, strong) NSMutableArray<InventoryMaterialStorageInInventory *> *inventory;  //物资数组

- (NSString *)getUrl;
@end


@interface InventoryMaterialStorageInResponse : BaseResponse

@end

