//
//  WorkOrderGrabEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/3.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"

@interface GrabWorkOrderRequestParam : BaseRequest

@property (readwrite, nonatomic, strong) NetPageParam * page;

- (instancetype) initWithPage:(NetPageParam *) page;
- (NSString*) getUrl;

@end

@interface WorkOrderGrab : NSObject
@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) NSString * woCode;
@property (readwrite, nonatomic, assign) NSInteger priority;
@property (readwrite, nonatomic, strong) NSString * woDescription;
@property (readwrite, nonatomic, strong) NSNumber * createDateTime;
@property (readwrite, nonatomic, strong) NSString * location;
@property (readwrite, nonatomic, assign) NSInteger status;          //工单状态
@property (readwrite, nonatomic, assign) NSInteger laborerStatus;   //当前执行人的状态
@property (readwrite, nonatomic, strong) NSString* projectName;     //项目名称

@property (readwrite, nonatomic, assign) NSInteger grabType;    //
@property (readwrite, nonatomic, assign) NSInteger grabStatus;

/* 位置信息 */
@property (readwrite, nonatomic, strong) NSNumber* cityId;
@property (readwrite, nonatomic, strong) NSNumber* siteId;
@property (readwrite, nonatomic, strong) NSNumber* buildingId;
@property (readwrite, nonatomic, strong) NSNumber* floorId;
@property (readwrite, nonatomic, strong) NSNumber* roomId;

//创建时间
- (NSString *) getCreateDateStr;
//优先级
- (NSString *) getPriorityName;

//是否可抢
- (BOOL) isGrabAble;
@end


