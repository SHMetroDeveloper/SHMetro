//
//  InventoryMaterialDetailEntity.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/28.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import <UIKit/UIKit.h>


@interface InventoryMaterialDetailAttachment : NSObject
@property (nonatomic, strong) NSNumber *fileId;
@property (nonatomic, strong) NSString *fileName;
@end


@interface InventoryMaterialDetail : NSObject
@property (nonatomic, strong) NSNumber *inventoryId;  //物资库存ID
@property (nonatomic, strong) NSString *code;  //物资编码
@property (nonatomic, strong) NSString *name;  //物资名称
@property (nonatomic, strong) NSNumber *warehouseId;  //仓库ID
@property (nonatomic, strong) NSString *warehouseName;  //仓库名称
@property (nonatomic, strong) NSString *brand;  //品牌
@property (nonatomic, strong) NSString *model;  //型号
@property (nonatomic, strong) NSString *unit;  //单位
@property (nonatomic, strong) NSString *price;  //核定价格
@property (nonatomic, strong) NSNumber *minNumber;  //最低库存数量
@property (nonatomic, strong) NSNumber *totalNumber;  //账面库存数量
@property (nonatomic, strong) NSNumber *realNumber;  //有效库存数量
@property (nonatomic, strong) NSNumber *reservedNumber;  //被预定库存数量
@property (nonatomic, strong) NSString *desc;  //备注
@property (nonatomic, strong) NSMutableArray<NSNumber *> *pictures;  //图片数组
@property (nonatomic, strong) NSMutableArray<InventoryMaterialDetailAttachment *> *attachment;  //设备

@end


//通过 ID 获取物料详情
@interface InventoryMaterialDetailIdRequestParam : BaseRequest
@property (nonatomic, strong) NSNumber *inventoryId;

- (NSString *) getUrl;
@end

//通过编码获取物料详情
@interface InventoryMaterialDetailCodeRequestParam : BaseRequest
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSNumber *warehouseId;
- (NSString *) getUrl;
@end

@interface InventoryMaterialDetailResponse : BaseResponse
@property (nonatomic, strong) InventoryMaterialDetail * data;
- (instancetype)init;
@end

