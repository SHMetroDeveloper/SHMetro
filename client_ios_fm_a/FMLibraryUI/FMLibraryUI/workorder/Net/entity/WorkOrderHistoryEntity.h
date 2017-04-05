//
//  WorkOrderHistoryEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/23.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"
#import "BaseDataEntity.h"
#import "BaseResponse.h"

@interface WorkOrderHistorySearchCondition : NSObject   //历史工单查询条件
@property (readwrite, nonatomic, strong) NSMutableArray * priority; //优先级数组
@property (readwrite, nonatomic, strong) NSMutableArray * status;   //状态

@property (readwrite, nonatomic, strong) NSNumber * startDateTime;  //起始时间
@property (readwrite, nonatomic, strong) NSNumber * endDateTime;    //截止时间
@property (readwrite, nonatomic, strong) Position * location;

- (instancetype) init;
@end

@interface WorkOrderHistoryRequestParam : BaseRequest   //历史工单请求参数

@property (readwrite, nonatomic, strong) WorkOrderHistorySearchCondition * searchCondition;
@property (readwrite, nonatomic, strong) NetPageParam * page;

- (instancetype) initWithSearchCondition:(WorkOrderHistorySearchCondition *) condition andPage:(NetPageParam *) page;
- (NSString*) getUrl;

@end


@interface WorkOrderHistory : NSObject

@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) NSString * code;
@property (readwrite, nonatomic, strong) NSString * pfmCode;    //pfm 编码
@property (readwrite, nonatomic, strong) NSNumber* priorityId;
@property (readwrite, nonatomic, strong) NSString * woDescription;
@property (readwrite, nonatomic, strong) NSNumber * createDateTime;
@property (readwrite, nonatomic, strong) NSString * location;
@property (readwrite, nonatomic, assign) NSInteger status;          //工单状态
@property (readwrite, nonatomic, assign) NSInteger currentLaborerStatus;   //当前执行人的状态
@property (readwrite, nonatomic, strong) NSNumber * actualCompletionDateTime;   //
@property (readwrite, nonatomic, strong) NSString * applicantName;
@property (readwrite, nonatomic, strong) NSString * applicantPhone;
@property (readwrite, nonatomic, strong) NSString * workContent;
@property (readwrite, nonatomic, strong) NSString * serviceTypeName;
//
@property (readwrite, nonatomic, assign) NSInteger grabType;

/* 位置信息 */
@property (readwrite, nonatomic, strong) NSNumber* cityId;
@property (readwrite, nonatomic, strong) NSNumber* siteId;
@property (readwrite, nonatomic, strong) NSNumber* buildingId;
@property (readwrite, nonatomic, strong) NSNumber* floorId;
@property (readwrite, nonatomic, strong) NSNumber* roomId;

- (instancetype) init;
- (NSString *) getFinishTimeStr;
- (NSString *) getCreateTimeStr;
- (NSString *) getStatusStr;
- (NSString *) getPriorityName;
- (NSString *) getReporter;
- (NSString *) getPhone;
@end

@interface WorkOrderHistoryResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * contents;
@end

@interface WorkOrderHistoryResponse : BaseResponse
@property (readwrite, nonatomic, strong) WorkOrderHistoryResponseData * data;
@end
