//
//  InventoryMaterialQueryEntity.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/28.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NetPage.h"

@interface InventoryMaterialQueryCondition : NSObject
@property (nonatomic, assign) NSInteger type;   //库存量  0--不限 1--充足 2--紧缺 3--有批次
@property (nonatomic, strong) NSString *name;   //物资名称
@property (nonatomic, strong) NSString *param;  //模糊查询条件字符
@end

@interface InventoryMaterialQueryRequestParam : BaseRequest
@property (nonatomic, strong) NSNumber *warehouseId;  //仓库ID
@property (nonatomic, strong) NetPageParam *page;
@property (nonatomic, strong) InventoryMaterialQueryCondition *condition;  //查询条件

- (NSString *)getUrl;
@end

@interface InventoryMaterialQueryDetail : NSObject
@property (nonatomic, strong) NSNumber *inventoryId;
@property (nonatomic, strong) NSString *materialCode;
@property (nonatomic, strong) NSString *materialName;
@property (nonatomic, strong) NSString *materialBrand;
@property (nonatomic, strong) NSString *materialModel;
@property (nonatomic, strong) NSString *materialUnit;  //物料单位
@property (nonatomic, assign) CGFloat totalNumber;  //账面库存数量
@property (nonatomic, assign) CGFloat minNumber;
@property (nonatomic, assign) CGFloat realNumber;   //有效数量
@property (nonatomic, strong) NSString *cost;  //物料单价
@property (nonatomic, strong) NSMutableArray *pictures;  //图片
@end

@interface InventoryMaterialQueryResponseData : NSObject
@property (nonatomic, strong) NetPage *page;
@property (nonatomic, strong) NSMutableArray *contents;
@end

@interface InventoryMaterialQueryResponse : BaseResponse
@property (nonatomic, strong) InventoryMaterialQueryResponseData *data;
@end

