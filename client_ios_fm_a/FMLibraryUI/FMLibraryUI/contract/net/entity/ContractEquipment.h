//
//  ContractEquipment.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NetPage.h"

//合同设备
@interface ContractEquipment : NSObject
@property (readwrite, nonatomic, strong) NSNumber * equipmentId;    //设备ID
@property (readwrite, nonatomic, strong) NSString * code;  //设备编码
@property (readwrite, nonatomic, strong) NSString * name;  //设备名称
@property (readwrite, nonatomic, strong) NSString * location;       //位置
@property (readwrite, nonatomic, strong) NSString * systemName;    //设备分类
@end

// 15.4 获取合同所关联的设备列表
@interface ContractEquipmentRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * contractId;
@property (readwrite, nonatomic, strong) NetPageParam * page;

- (instancetype)initWithContractId:(NSNumber *) contractId andPage:(NetPage *) page;
- (NSString *)getUrl;
@end

//
@interface ContractEquipmentResponseData : NSObject
@property (readwrite, nonatomic, strong) NSMutableArray *contents;
@property (readwrite, nonatomic, strong) NetPage *page;
@end

//合同设备请求结果
@interface ContractEquipmentResponse : BaseResponse
@property (readwrite, nonatomic, strong) ContractEquipmentResponseData *data;
@end
