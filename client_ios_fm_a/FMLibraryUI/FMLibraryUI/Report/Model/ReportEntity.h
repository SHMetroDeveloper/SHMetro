//
//  ReportEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"
#import "BaseDataEntity.h"



//报障设备
@interface ReportDevice : NSObject
@property (readwrite, nonatomic, strong) NSNumber * deviceId;
@end

//报障上传返回的结果
@interface ReportResponseData : NSObject
@property (readwrite, nonatomic, strong) NSNumber * reportId;
@end

//报障
@interface Report : NSObject
@property (readwrite, nonatomic, strong) NSNumber * userId;
@property (readwrite, nonatomic, strong) NSNumber * patrolItemDetailId;//如果是跟巡检相关联的问题，则为问题ID
@property (readwrite, nonatomic, strong) NSNumber * reqId;  //如果是跟需求相关联，则为需求ID
@property (readwrite, nonatomic, strong) NSString* phone;
@property (readwrite, nonatomic, strong) NSString* name;
@property (readwrite, nonatomic, strong) NSNumber * orgId;
@property (readwrite, nonatomic, strong) NSNumber * stypeId;
@property (readwrite, nonatomic, strong) NSNumber * priorityId;
@property (readwrite, nonatomic, strong) NSString* desc;
@property (readwrite, nonatomic, assign) NSInteger images;
@property (readwrite, nonatomic, strong) Position* position;
@property (readwrite, nonatomic, strong) NSMutableArray* devices;
@property (readwrite, nonatomic, assign) BOOL isValidation;
@property (readwrite, nonatomic, strong) NSNumber * processId;
@property (readwrite, nonatomic, assign) NSInteger orderType;   //工单类型---纠正性维护，自检

- (instancetype) init;
- (NSString *) getUserName;
@end

//报障上传请求
@interface ReportUploadRequest : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * userId;
@property (readwrite, nonatomic, strong) NSString* name;
@property (readwrite, nonatomic, strong) NSString* phone;
@property (readwrite, nonatomic, strong) NSNumber * organizationId;
@property (readwrite, nonatomic, strong) NSNumber * serviceTypeId;
@property (readwrite, nonatomic, strong) NSString* scDescription;
@property (readwrite, nonatomic, strong) NSNumber * priorityId;
@property (readwrite, nonatomic, strong) Position* location;
@property (readwrite, nonatomic, strong) NSMutableArray* equipmentIds;
@property (readwrite, nonatomic, strong) NSNumber * processId;
@property (readwrite, nonatomic, strong) NSNumber * patrolItemDetailId;
@property (readwrite, nonatomic, strong) NSNumber * reqId;
@property (readwrite, nonatomic, assign) NSInteger woType;
@property (readwrite, nonatomic, strong) NSMutableArray * pictures; //报障图片
//@property (readwrite, nonatomic, assign) NSInteger scope;
- (instancetype) initWith:(Report *) report;
- (NSString*) getUrl;
@end

@interface ReportEntity : NSObject
@end