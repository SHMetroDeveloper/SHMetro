//
//  ReserveMaterialEntity.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseRequest.h"
#import "BaseResponse.h"

//预定的库存
@interface InventoryReserveEntity : NSObject
@property (readwrite, nonatomic, strong) NSNumber *inventoryId;   //物料ID
@property (readwrite, nonatomic, strong) NSString * amount;   //物料数量
@end

//预定库存
@interface ReserveInventoryRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * userId;  //申请人ID
@property (readwrite, nonatomic, strong) NSNumber * date;   //预约时间
@property (readwrite, nonatomic, strong) NSString * desc;   //预约说明
@property (readwrite, nonatomic, strong) NSNumber * woId;   //关联工单ID
@property (readwrite, nonatomic, strong) NSString * woCode;   //关联工单编码
@property (readwrite, nonatomic, strong) NSNumber * warehouseId;   //仓库ID
@property (readwrite, nonatomic, strong) NSNumber * administrator;   //仓库管理员ID
@property (readwrite, nonatomic, strong) NSNumber * supervisor;    //主管ID
@property (readwrite, nonatomic, strong) NSMutableArray * materials;   //物料数组
- (instancetype) init;
- (NSString *) getUrl;
@end

@interface ReserveInventoryResponse : BaseResponse
@property (readwrite, nonatomic, strong) NSNumber * data;
@end
