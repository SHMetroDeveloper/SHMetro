//
//  WarehouseEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NetPage.h"

//仓库管理员
@interface WarehouseAdministrator : NSObject
@property (readwrite, nonatomic, strong) NSNumber* administratorId;
@property (readwrite, nonatomic, strong) NSString* name;
@end

//仓库
@interface WarehouseEntity : NSObject
@property (readwrite, nonatomic, strong) NSNumber* warehouseId;
@property (readwrite, nonatomic, strong) NSString* name;
@property (readwrite, nonatomic, strong) NSMutableArray * administrator;
@end

//获取仓库参数
@interface InventoryGetWarehouseParam : BaseRequest
@property (readwrite, nonatomic, strong) NetPageParam* page;
@property (readwrite, nonatomic, strong) NSNumber * employeeId;
- (instancetype) initWith:(NetPageParam *) page employeeId:(NSNumber *) emId;
- (NSString*) getUrl;
@end


@interface InventoryGetWarehouseResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * contents;
@end

@interface InventoryGetWarehouseResponse : BaseResponse
@property (readwrite, nonatomic, strong) InventoryGetWarehouseResponseData * data;
@end
