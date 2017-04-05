//
//  AttendanceRecordEntity.h
//  FMLibraryUI
//
//  Created by Jonzzs on 2017/3/8.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NetPage.h"
#import "BaseDataEntity.h"

@interface AttendanceRecordEntity : NSObject

@property (nonatomic,strong) NSNumber *contactId;
@property (nonatomic,strong) NSString *contactName;
@property (nonatomic,strong) NSString *locationName;
@property (nonatomic,strong) Position *location;
@property (nonatomic,strong) NSNumber *createTime;

@end


#pragma mark - 签到记录列表

@interface AttendanceRecordResponseData : NSObject

@property (nonatomic, strong) NetPage *page;
@property (nonatomic, strong) NSMutableArray *contents;

@end

@interface AttendanceRecordResponse : BaseResponse

@property (nonatomic, strong) AttendanceRecordResponseData *data;

@end


/**
 签到记录的请求实体
 */
@interface AttendanceRecordRequest : BaseRequest

@property (nonatomic, strong) NSNumber *timeStart; //开始时间
@property (nonatomic, strong) NSNumber *timeEnd; //结束时间
@property (nonatomic, strong) NetPageParam *page; //分页

- (instancetype)initWithTimeStart:(NSNumber *)timeStart
                          timeEnd:(NSNumber *)timeEnd
                             page:(NetPageParam *)page;

- (NSString *)getUrl;

@end


#pragma mark - 最后一次签到记录

@interface LastAttendanceRecordResponse : BaseResponse

@property (nonatomic, strong) AttendanceRecordEntity *data;

@end


/**
 最后一次签到记录的请求实体
 */
@interface LastAttendanceRecordRequest : BaseRequest

- (NSString *)getUrl;

@end
