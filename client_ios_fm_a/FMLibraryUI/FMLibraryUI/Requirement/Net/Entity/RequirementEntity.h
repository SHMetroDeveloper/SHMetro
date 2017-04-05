//
//  DemandListEntity.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/12/22.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "BaseDataEntity.h"
#import "NetPage.h"


@interface RequirementRequestCondition : NSObject
@property (readwrite, nonatomic, strong) NSNumber * timeStart;
@property (readwrite, nonatomic, strong) NSNumber * timeEnd;
@end


@interface RequirementRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NetPageParam * page;
@property (readwrite, nonatomic, assign) NSInteger queryType;
@property (readwrite, nonatomic, strong) NSNumber * timeStart;
@property (readwrite, nonatomic, strong) NSNumber * timeEnd;

- (instancetype) initWithPage:(NetPageParam *) page
                 andQueryType:(NSInteger) queryType
                 andCondition:(RequirementRequestCondition *) condition;
- (NSString *) getUrl;

@end


@interface RequirementEntity : NSObject

@property (readwrite, nonatomic, assign) NSInteger status;     //状态 ：已创建，处理中，已完成
@property (readwrite, nonatomic, assign) NSInteger origin; //需求来源 ：web后台，微信，移动端
@property (readwrite, nonatomic, strong) NSString * code;        //需求编号
@property (readwrite, nonatomic, strong) NSString * requester;    //需求者名称
@property (readwrite, nonatomic, strong) NSString * type;        //类型 如“投诉”，“咨询”
@property (readwrite, nonatomic, strong) NSNumber * reqId;    //需求ID
@property (readwrite, nonatomic, strong) NSString * desc;        //需求描述
@property (readwrite, nonatomic, strong) NSNumber * createDate;  //创建日期

- (NSString *) getStatusDescription;
- (NSString *) getOriginDescription;
- (NSString *) getTimeDescription;
@end


@interface RequirementEntityResponseData : NSObject
@property (nonatomic, strong) NetPage * page;
@property (nonatomic, strong) NSMutableArray * contents;
@end

@interface RequirementEntityResponse : BaseResponse

@property (nonatomic, strong) RequirementEntityResponseData * data;

@end

