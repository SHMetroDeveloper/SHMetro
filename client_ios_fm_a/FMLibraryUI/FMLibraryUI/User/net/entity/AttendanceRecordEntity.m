//
//  AttendanceRecordEntity.m
//  FMLibraryUI
//
//  Created by Jonzzs on 2017/3/8.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "AttendanceRecordEntity.h"
#import "SystemConfig.h"
#import "UserServerConfig.h"

@implementation AttendanceRecordEntity

@end


#pragma mark - 签到记录列表

@implementation AttendanceRecordResponseData

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{ @"contents" : @"AttendanceRecordEntity" };
}

@end


@implementation AttendanceRecordResponse

@end


/**
 签到记录的请求实体
 */
@implementation AttendanceRecordRequest

- (instancetype)initWithTimeStart:(NSNumber *)timeStart
                          timeEnd:(NSNumber *)timeEnd
                          page:(NetPageParam *)page {
    
    self = [super init];
    if(self) {
        
        _timeStart = timeStart;
        _timeEnd = timeEnd;
        _page = page;
    }
    return self;
}

- (NSString *)getUrl {
    
    NSString* url = [self wrapUrl:[[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], USER_ATTENDANCE_RECORD_LIST_URL]];
    
    return url;
}

@end


#pragma mark - 最后一次签到记录

@implementation LastAttendanceRecordResponse

@end


/**
 签到记录的请求实体
 */
@implementation LastAttendanceRecordRequest

- (NSString *)getUrl {
    
    NSString* url = [self wrapUrl:[[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], USER_ATTENDANCE_RECORD_LAST_URL]];
    
    return url;
}

@end
