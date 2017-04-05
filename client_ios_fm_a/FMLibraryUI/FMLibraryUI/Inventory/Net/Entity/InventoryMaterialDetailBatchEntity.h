//
//  InventoryMaterialDetailBatchEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/29/16.
//  Copyright © 2016 facilityone. All rights reserved.
//
//  物资批次

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NetPage.h"

typedef NS_ENUM(NSInteger, InventoryGetMaterialDetailBatchType) {
    INVENTORY_MATERIAL_DETAIL_GET_BATCH_ALL = 0,    //获取所有批次
    INVENTORY_MATERIAL_DETAIL_GET_BATCH_VALID = 1,  //获取有效批次（账面数量大于 0）
};

@interface InventoryMaterialDetailBatchEntity : NSObject
@property (readwrite, nonatomic, strong) NSNumber * batchId;        //批次ID
@property (readwrite, nonatomic, strong) NSString * providerName;   //供应商名字
@property (readwrite, nonatomic, strong) NSNumber * date;           //入库日期
@property (readwrite, nonatomic, strong) NSNumber * dueDate;        //过期时间
@property (readwrite, nonatomic, strong) NSNumber * amount;          //批次账面数量
@property (readwrite, nonatomic, strong) NSString * cost;           //单价
@end


@interface InventoryGetMaterialDetailBatchParam : BaseRequest
@property (readwrite, nonatomic, assign) InventoryGetMaterialDetailBatchType type;
@property (readwrite, nonatomic, strong) NSNumber * inventoryId;
@property (readwrite, nonatomic, strong) NetPageParam * page;
@end


@interface InventoryGetMaterialDetailBatchResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * contents;
@end

@interface InventoryGetMaterialDetailBatchResponse : BaseResponse
@property (readwrite, nonatomic, strong) InventoryGetMaterialDetailBatchResponseData * data;
@end
