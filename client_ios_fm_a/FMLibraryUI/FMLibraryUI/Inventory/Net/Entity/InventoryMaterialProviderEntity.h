//
//  InventoryMaterialProviderEntity.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/28.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NetPage.h"

@interface InventoryMaterialProviderRequestParam : BaseRequest
@property (nonatomic, strong) NSNumber *inventoryId;
@property (nonatomic, strong) NetPageParam * page;
- (instancetype)init;
@end


@interface InventoryMaterialProviderDetail : NSObject
@property (nonatomic, strong) NSNumber *providerId;  //供应商ID
@property (nonatomic, strong) NSString *name;  //供应商名字
@property (nonatomic, strong) NSString *phone;  //联系电话
@property (nonatomic, strong) NSString *address;  //地址
@property (nonatomic, strong) NSString *contact;  //联系人
@end


@interface InventoryMaterialProviderResponseData : NSObject
@property (nonatomic, strong) NetPage *page;
@property (nonatomic, strong) NSMutableArray *contents;
@end


@interface InventoryMaterialProviderResponse : BaseResponse
@property (nonatomic, strong) InventoryMaterialProviderResponseData *data;
@end


