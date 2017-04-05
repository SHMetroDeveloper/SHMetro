//
//  InventoryWarehouseQueryEntity.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/5.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NetPage.h"


@interface InventoryWarehouseQueryRequestParam : BaseRequest
@property (nonatomic, strong) NetPageParam *page;

- (instancetype)initWithPageNumber:(NSNumber *)pageNumber andPageSize:(NSNumber *)pageSize;

- (NSString *)getUrl;

@end


@interface InventoryWarehouseDetail : NSObject
@property (nonatomic, strong) NSNumber *warehouseId;
@property (nonatomic, strong) NSString *warehouseName;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *materialTypeCount;
@property (nonatomic, strong) NSString *materialCount;
@end


@interface InventoryWarehouseQueryResponseData : NSObject
@property (nonatomic, strong) NetPage *page;
@property (nonatomic, strong) NSMutableArray *contents;
@end


@interface InventoryWarehouseQueryResponse : BaseResponse
@property (nonatomic, strong) InventoryWarehouseQueryResponseData *data;
@end

