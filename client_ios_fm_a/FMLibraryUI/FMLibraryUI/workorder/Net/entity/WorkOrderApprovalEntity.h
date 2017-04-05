//
//  WorkOrderApprovalEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/23.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  待审批工单

#import <Foundation/Foundation.h>
#import "BaseResponse.h"
#import "BaseRequest.h"
#import "NetPage.h"

@interface WorkOrderApprovalRequestParam : BaseRequest

@property (readwrite, nonatomic, strong) NetPageParam * page;

- (instancetype) initWithPage:(NetPageParam *) page;
- (NSString*) getUrl;

@end

@interface WorkOrderApprovalContentItem : NSObject
@property (readwrite, nonatomic, strong) NSString * name;   //键
@property (readwrite, nonatomic, strong) NSString * value;  //值
@end

@interface ApprovalContentItem : NSObject
@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * value;
@end

@interface ApprovalResult : NSObject
@property (readwrite, nonatomic, strong) NSString * approver;
@property (readwrite, nonatomic, strong) NSNumber * result;
@property (readwrite, nonatomic, strong) NSString * arDescription;  //备注
@end

@interface WorkOrderApproval : NSObject

@property (readwrite, nonatomic, strong) NSNumber * woId;    //工单ID
@property (readwrite, nonatomic, strong) NSString * code;       //单号
@property (readwrite, nonatomic, strong) NSString * pfmCode;    //pfm 编码
@property (readwrite, nonatomic, strong) NSString * location;       //位置
@property (readwrite, nonatomic, strong) NSNumber * actualCompletionDateTime;    //完成日期
@property (readwrite, nonatomic, strong) NSString * woDescription;       //审批描述
@property (readwrite, nonatomic, strong) NSNumber * approvalId;
@property (readwrite, nonatomic, strong) NSString * applicantName;
@property (readwrite, nonatomic, strong) NSString * applicantPhone;
@property (readwrite, nonatomic, strong) NSString * serviceTypeName;
@property (readwrite, nonatomic, strong) NSNumber * createDateTime;
@property (readwrite, nonatomic, strong) NSNumber * approvalSubmitDateTime;
@property (readwrite, nonatomic, assign) NSInteger currentLaborerStatus;
@property (readwrite, nonatomic, strong) NSNumber * priorityId;
@property (readwrite, nonatomic, assign) NSInteger status;
@property (readwrite, nonatomic, strong) NSString * workContent;
@property (readwrite, nonatomic, strong) NSMutableArray * approvalContent;  //键值对数组

- (instancetype) init;
//- (instancetype) initWithDictionary:(NSDictionary *) dic;  //此处初始化了待审核工单实体 并解析了网络数据

- (NSString *) getCreateDateStr;
- (NSString *) getStatusStr;
- (NSString *) getPriorityName;
- (NSString *) getEndDateStr;
- (NSString *) getApprovalContent;

- (instancetype) copy;
@end

@interface ApprovalWorkOrderResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * contents;
@end

@interface ApprovalWorkOrderResponse : BaseResponse
@property (readwrite, nonatomic, strong) ApprovalWorkOrderResponseData * data;
//- (instancetype) init;
@end




