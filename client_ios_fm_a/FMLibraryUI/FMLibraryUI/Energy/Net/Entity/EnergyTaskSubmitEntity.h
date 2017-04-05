//
//  ParameterDetailEntity.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/27.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"
#import "BaseResponse.h"
#import "BaseDataEntity.h"

@interface EnergyTaskSubmitParam : BaseRequest

@property (readwrite, nonatomic, strong) NSNumber * meterReadingId; //任务ID
@property (readwrite, nonatomic, strong) NSNumber * startDateTime;  //任务开始时间
@property (readwrite, nonatomic, strong) NSNumber * endDateTime;    //任务结束时间
@property (readwrite, nonatomic, strong) NSMutableArray * results;  //所有抄表项

- (instancetype)initWithMeterReadingId:(NSNumber *) meterReadingId
                         startDateTime:(NSNumber *) startDateTime
                           endDateTime:(NSNumber *) endDateTime
                               results:(NSMutableArray *)results;
- (NSString *)getUrl;

@end


@interface EnergyTaskResultItem : NSObject

@property (readwrite, nonatomic, strong) NSNumber * meterId;
@property (readwrite, nonatomic, strong) NSString * result;

@end

@interface EnergyTaskSubmitResponse : BaseResponse

@end


