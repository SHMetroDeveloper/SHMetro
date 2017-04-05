//
//  InventoryMaterialDetailRecordEntity.h
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

@interface InventoryMaterialDetailRecordRequestParam : BaseRequest
@property (nonatomic, strong) NSNumber *inventoryId;
@property (nonatomic, strong) NetPageParam *page;
- (instancetype)init;
@end

@interface InventoryMaterialDetailRecordDetail : NSObject
@property (nonatomic, strong) NSNumber *recordId;  //记录ID
@property (nonatomic, strong) NSString *code;  //入库单号
@property (nonatomic, strong) NSString *provider;  //供应商
@property (nonatomic, strong) NSString *price;  //单价
@property (nonatomic, strong) NSNumber * number;  //入库数量
@property (nonatomic, strong) NSNumber * validNumber;  //有效数量
@property (nonatomic, strong) NSNumber *date;   //入库时间戳
@property (nonatomic, strong) NSNumber *dueDate;  //过期时间
@end


@interface InventoryMaterialDetailRecordResponseData : NSObject
@property (nonatomic, strong) NetPage *page;
@property (nonatomic, strong) NSMutableArray *contents;
@end

@interface InventoryMaterialDetailRecordResponse : BaseResponse
@property (nonatomic, strong) InventoryMaterialDetailRecordResponseData * data;
@end
