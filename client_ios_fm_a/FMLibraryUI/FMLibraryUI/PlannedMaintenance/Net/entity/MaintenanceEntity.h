//
//  MaintenanceEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/27.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"
#import "BaseResponse.h"

//维护日历请求
@interface MaintenanceCalendarRequestParam : BaseRequest

@property (readwrite,nonatomic,strong) NSNumber *  startTime;
@property (readwrite,nonatomic,strong) NSNumber *  endTime;

- (instancetype)initWithConditionStartTime:(NSNumber *)startTime endTime:(NSNumber *)endTime;
- (NSString*) getUrl;

@end


@interface MaintenanceEntity : NSObject

@property (readwrite, nonatomic, strong) NSNumber * pmId;
@property (readwrite, nonatomic, strong) NSString * pmName;
@property (readwrite, nonatomic, strong) NSNumber * pmtodoId;

@property (readwrite, nonatomic, strong) NSNumber * dateTodo;

@property (readwrite, nonatomic, assign) BOOL genStatus;    //是否生成工单
@property (readwrite, nonatomic, strong) NSMutableArray * woIds;

@property (readwrite, nonatomic, assign) NSInteger status;  //1未处理，2处理中，3已结束，4遗漏

- (instancetype) init;

//开始时间
- (NSString *) getStartDateStr;
//获取状态描述
- (NSString *) getStatusDesc;
@end


@interface MaintenanceCalendarResponse : BaseResponse
@property ( nonatomic, strong) NSMutableArray * data;
@end



