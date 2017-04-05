//
//  WorkOrderValidateEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/8.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"
#import "BaseResponse.h"

@interface WorkOrderUnValidatedRequestParam : BaseRequest

@property (readwrite, nonatomic, strong) NetPageParam * page;

- (instancetype) initWithPage:(NetPageParam *) page;
- (NSString*) getUrl;

@end

@interface WorkOrderUnValidatedEntity : NSObject
@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) NSString * code;
@property (readwrite, nonatomic, strong) NSString * pfmCode;
@property (readwrite, nonatomic, assign) NSInteger priorityId;
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

/* 位置信息 */
@property (readwrite, nonatomic, strong) NSNumber* cityId;
@property (readwrite, nonatomic, strong) NSNumber* siteId;
@property (readwrite, nonatomic, strong) NSNumber* buildingId;
@property (readwrite, nonatomic, strong) NSNumber* floorId;
@property (readwrite, nonatomic, strong) NSNumber* roomId;

- (instancetype) init;

//创建时间
- (NSString *) getCreateDateStr;
//优先级
- (NSString *) getPriorityName;
@end


@interface WorkOrderUnValidatedResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * contents;
@end

@interface WorkOrderUnValidatedResponse : BaseResponse
@property (readwrite, nonatomic, strong) WorkOrderUnValidatedResponseData * data;
- (instancetype) init;
@end
