//
//  MyReportHistoryEntity.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/11/10.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"
#import "BaseDataEntity.h"
#import "BaseResponse.h"

@interface MyReportSearchCondition : NSObject   //历史工单查询条件
@property (readwrite, nonatomic, strong) NSMutableArray * priority; //优先级数组
@property (readwrite, nonatomic, strong) NSMutableArray * status;   //状态

@property (readwrite, nonatomic, strong) NSNumber * startDateTime;  //起始时间
@property (readwrite, nonatomic, strong) NSNumber * endDateTime;    //截止时间
@property (readwrite, nonatomic, strong) Position * location;
@property (readwrite, nonatomic, strong) NSNumber * emId;

- (instancetype) init;
@end


@interface MyReportRequestParam : BaseRequest   //我的报障工单请求参数

@property (readwrite, nonatomic, strong) MyReportSearchCondition * searchCondition;
@property (readwrite, nonatomic, strong) NetPageParam * page;

- (instancetype) initWithRequestPage:(NetPageParam *)page;

- (NSString*) getUrl;

@end

@interface MyReportHistory : NSObject

@property (readwrite, nonatomic, strong) NSNumber * woId;   //工单ID
@property (readwrite, nonatomic, strong) NSString * code;   //工单号
@property (readwrite, nonatomic, strong) NSNumber * createDateTime; //创建时间
@property (readwrite, nonatomic, strong) NSString * woDescription;
@property (readwrite, nonatomic, assign) NSInteger  status;
@property (readwrite, nonatomic, strong) NSString * serviceTypeName;
@property (readwrite, nonatomic, strong) NSString * location;
@property (readwrite, nonatomic, strong) NSNumber * priorityId;
@property (readwrite, nonatomic, assign) NSInteger currentLaborerStatus;

- (instancetype) init;
//创建时间
- (NSString *) getCreateTimeStr;

@end

@interface MyreportHistoryResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * contents;
@end

@interface MyreportHistoryResponse : BaseRequest
@property (readwrite, nonatomic, strong) MyreportHistoryResponseData * data;
@end

