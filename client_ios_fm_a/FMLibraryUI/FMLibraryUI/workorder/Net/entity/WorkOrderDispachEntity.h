//
//  WorkOrderDispachEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/23.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  待派工工单

#import <Foundation/Foundation.h>
#import "BaseResponse.h"
#import "BaseRequest.h"
#import "NetPage.h"

@interface WorkOrderDispachRequestParam : BaseRequest

@property (readwrite, nonatomic, strong) NetPageParam * page;

- (instancetype) initWithPage:(NetPageParam *) page;
- (NSString*) getUrl;

@end


@interface WorkOrderDispach : NSObject

@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) NSString * code;
@property (readwrite, nonatomic, strong) NSString * pfmCode;    //pfm 编码
@property (readwrite, nonatomic, assign) NSInteger priorityId;
@property (readwrite, nonatomic, assign) NSInteger status;
@property (readwrite, nonatomic, strong) NSString * serviceTypeName;
@property (readwrite, nonatomic, strong) NSString * workContent;
@property (readwrite, nonatomic, strong) NSString * woDescription;
@property (readwrite, nonatomic, strong) NSNumber * createDateTime;
@property (readwrite, nonatomic, strong) NSString * applicantName;
@property (readwrite, nonatomic, strong) NSString * applicantPhone;
@property (readwrite, nonatomic, strong) NSString * location;

@property (readwrite, nonatomic, assign) NSInteger grabType;

/* 位置信息 */
@property (readwrite, nonatomic, strong) NSNumber* cityId;
@property (readwrite, nonatomic, strong) NSNumber* siteId;
@property (readwrite, nonatomic, strong) NSNumber* buildingId;
@property (readwrite, nonatomic, strong) NSNumber* floorId;
@property (readwrite, nonatomic, strong) NSNumber* roomId;


- (instancetype) init;

//获取创建时间
- (NSString *) getCreateDateStr;
- (NSString *) getStatusStr;
- (NSString *) getPriorityName;
- (instancetype) copy;

@end


@interface DispachWorkOrderResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * contents;
@end

@interface DispachWorkOrderResponse : BaseResponse
@property (readwrite, nonatomic, strong) DispachWorkOrderResponseData * data;
@end







