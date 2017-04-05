//
//  DemandDetailEntity.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/12/22.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDataEntity.h"
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NetPage.h"


@interface RequirementDetailRequestParam : BaseRequest

@property (readwrite, nonatomic, strong) NSNumber * reqId;

- (instancetype) initWithReqId:(NSNumber *) reqId;
- (NSString*) getUrl;

@end

@interface RequirementRequestor : NSObject
@property (readwrite, nonatomic, strong) NSNumber * userId;           //需求人ID
@property (readwrite, nonatomic, strong) NSString * name;              //
@property (readwrite, nonatomic, strong) NSString * position;        //职位
@property (readwrite, nonatomic, strong) NSString * appellation;    //称谓
@property (readwrite, nonatomic, strong) NSString * department;     //部门
@property (readwrite, nonatomic, strong) NSString * telephone;      //电话
@property (readwrite, nonatomic, strong) NSString * mobile;         //手机号
@property (readwrite, nonatomic, assign) NSInteger type;           //类型：0---无；1---employee；2---customer
@end

@interface RequirementRecord : NSObject
@property (readwrite, nonatomic, strong) NSNumber * recordId;     //处理记录ID
@property (readwrite, nonatomic, strong) NSNumber * date;         //处理时间
@property (readwrite, nonatomic, strong) NSString * content;      //处理内容
@property (readwrite, nonatomic, assign) NSInteger recordType;    //处理类型
@property (readwrite, nonatomic, strong) NSString * handler;      //处理人
@end

@interface RequirementOrder : NSObject
@property (readwrite, nonatomic, strong) NSNumber * woId;    //工单ID
@property (readwrite, nonatomic, strong) NSString * code;    //工单编号
@property (readwrite, nonatomic, assign) NSInteger status;   //工单状态
@end

@interface RequirementAttachment : NSObject
@property (nonatomic, strong) NSNumber *fileId;
@property (nonatomic, strong) NSString *fileName;
@end

@interface RequirementEquipment : NSObject
@property (nonatomic, strong) NSNumber *eqId;
@property (nonatomic, strong) NSString *eqCode;
@property (nonatomic, strong) NSString *eqName;
@end

@interface RequirementDetailEntity : NSObject
@property (readwrite, nonatomic, strong) NSNumber *reqId;           //需求ID
@property (readwrite, nonatomic, strong) NSString *code;           //需求编码
@property (readwrite, nonatomic, strong) NSString *serviceType;           //需求类型，如咨询，报障
@property (readwrite, nonatomic, assign) NSInteger status;
@property (readwrite, nonatomic, assign) NSInteger origin;
@property (readwrite, nonatomic, strong) NSString *desc;
@property (readwrite, nonatomic, strong) NSNumber *createDate;
@property (readwrite, nonatomic, strong) NSString *telephone;
@property (readwrite, nonatomic, strong) NSString *location;
@property (readwrite, nonatomic, strong) RequirementRequestor *requester;
@property (readwrite, nonatomic, strong) NSMutableArray * records;
@property (readwrite, nonatomic, strong) NSMutableArray * orders;
@property (readwrite, nonatomic, strong) NSMutableArray * images;   //图片
@property (readwrite, nonatomic, strong) NSMutableArray * audios;   //音频
@property (readwrite, nonatomic, strong) NSMutableArray * videos;   //视频
@property (readwrite, nonatomic, strong) NSMutableArray * attachment;   //附件
@property (readwrite, nonatomic, strong) NSMutableArray * equipment;   //设备

- (instancetype) init;

//获取状态的描述
- (NSString *) getStatusDescription;

//获取来源的描述
- (NSString *) getOriginDescription;

//获取时间的描述
- (NSString *) getTimeDescription;
@end


@interface RequirementDetailResponse : BaseResponse
@property (nonatomic, strong) RequirementDetailEntity * data;
@end




