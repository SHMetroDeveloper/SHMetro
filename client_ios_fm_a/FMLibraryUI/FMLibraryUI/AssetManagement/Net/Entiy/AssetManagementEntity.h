//
//  AssetManagementEntity.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/2.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"
#import "BaseResponse.h"
#import "BaseDataEntity.h"


@interface SearchCondition : NSObject
@property (readwrite, nonatomic, strong) NSString * equipmentCode;
@property (readwrite, nonatomic, strong) NSString * basicinformation;
@property (readwrite, nonatomic, strong) Position * location;
@property (readwrite, nonatomic, strong) NSString * system;
@property (readwrite, nonatomic, strong) NSMutableArray * status;
@end



@interface AssetManagementEquipmentsRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NetPageParam * page;
@property (readwrite, nonatomic, strong) SearchCondition * searchCondition;

- (instancetype) init;
- (instancetype) initWithCondition:(SearchCondition *) searchCondition andPage:(NetPageParam *) page;
- (NSString *)getUrl;
@end



@interface AssetManagementEquipmentsEntity : NSObject

@property (nonatomic, strong) NSNumber *eqId;   //设备编码
@property (nonatomic, strong) NSString *code; //基础信息
@property (nonatomic, strong) NSString *name; //设备名称
@property (nonatomic, strong) NSString *equSysName;    //设备所属系统
@property (nonatomic, assign) NSInteger maintainNumber; //维保个数
@property (nonatomic, strong) NSString *location;      //设备位置
@property (nonatomic, assign) NSInteger repairNumber;   //维修个数
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *sysType;

- (NSString *) getEquipmentNameDesc;

- (NSString *) getStatusStr;

@end



@interface AssetManagementEquipmentsResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * contents;
@end



@interface AssetManagementEquipmentsResponse : BaseResponse
@property (readwrite, nonatomic, strong) AssetManagementEquipmentsResponseData * data;
@end

