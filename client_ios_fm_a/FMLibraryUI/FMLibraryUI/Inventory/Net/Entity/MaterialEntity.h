//
//  MaterialEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NetPage.h"
#import <UIKit/UIKit.h>

//库存类型，
typedef NS_ENUM(NSInteger, InventoryGetMaterialType) {
    INVENTORY_GET_MATERIAL_TYPE_ALL,        //不限
    INVENTORY_GET_MATERIAL_TYPE_ENOUGH,     //充足
    INVENTORY_GET_MATERIAL_TYPE_SHORTAGE,   //紧缺
    INVENTORY_GET_MATERIAL_TYPE_BATCH_ABLE,   //有批次
};

//物料
@interface MaterialEntity : NSObject
@property (nonatomic, strong) NSNumber *inventoryId;
@property (nonatomic, strong) NSString *materialCode;
@property (nonatomic, strong) NSString *materialName;
@property (nonatomic, strong) NSString *materialBrand;
@property (nonatomic, strong) NSString *materialModel;
@property (nonatomic, strong) NSString *materialUnit;  //物料单位
@property (nonatomic, strong) NSNumber * minNumber;
@property (nonatomic, strong) NSNumber * totalNumber; //库存账面数量
@property (nonatomic, strong) NSNumber * realNumber;   //有效数量
@property (nonatomic, strong) NSString *cost;  //物料单价
@property (nonatomic, strong) NSMutableArray *pictures;  //图片
@end

@interface InventoryGetMaterialCondition : NSObject
@property (readwrite, nonatomic, assign) InventoryGetMaterialType type;    //库存类型
@property (readwrite, nonatomic, strong) NSString * name;   //名字
@property (readwrite, nonatomic, strong) NSString * param;  //模糊过滤条件，过滤物料编码，品牌，型号
@end

//获取仓库参数
@interface InventoryGetMaterialParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * warehouseId;
@property (readwrite, nonatomic, strong) InventoryGetMaterialCondition * condition;
@property (readwrite, nonatomic, strong) NetPageParam* page;

- (instancetype) initWith:(NetPageParam *) page warehouse:(NSNumber *) warehouseId;
- (instancetype) initWith:(NetPageParam *) page warehouse:(NSNumber *) warehouseId condition:(InventoryGetMaterialCondition *) condition;
- (NSString*) getUrl;
@end


@interface InventoryGetMaterialResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * contents;
@end

@interface InventoryGetMaterialResponse : BaseResponse
@property (readwrite, nonatomic, strong) InventoryGetMaterialResponseData * data;
@end
