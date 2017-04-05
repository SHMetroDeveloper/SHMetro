//
//  MissionListEntity.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/27.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"
#import "BaseResponse.h"

@interface EnergyTaskListRequestParam : BaseRequest

@property (readwrite, nonatomic, strong) NSNumber * preRequestDate;
@property (readwrite, nonatomic, strong) NetPageParam * page;

- (instancetype) initWithpreRequestDate:(NSNumber *)preRequestDate page:(NetPageParam *) page;
- (NSString *) getUrl;

@end

@interface EnergyTaskEntity : NSObject
@property (readwrite, nonatomic, strong) NSString * meterReadingName; //任务名称
@property (readwrite, nonatomic, strong) NSNumber * meterReadingId;   //任务ID
@property (readwrite, nonatomic, assign) BOOL deleted;                //是否删除
@property (readwrite, nonatomic, strong) NSNumber * readingCycle;     //任务周期
@property (readwrite, nonatomic, strong) NSNumber * lastSubmitTime;   //上次提交任务的时间
@property (readwrite, nonatomic, strong) NSMutableArray * meters;     //所有抄表项
- (instancetype)init;

@end

@interface EnergyTaskDetailEntity : NSObject
@property (readwrite, nonatomic, strong) NSString * location;         //位置
@property (readwrite, nonatomic, assign) BOOL deleted;                //是否删除
@property (readwrite, nonatomic, strong) NSNumber * meterId;          //超表项ID
@property (readwrite, nonatomic, strong) NSString * meterName;        //抄表项名称
@property (readwrite, nonatomic, strong) NSString * unit;             //单位

@end

@interface EnergyTaskListResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * contents;
@end

@interface EnergyTaskListResponse : BaseResponse
@property (readwrite, nonatomic, strong) EnergyTaskListResponseData * data;
@end
