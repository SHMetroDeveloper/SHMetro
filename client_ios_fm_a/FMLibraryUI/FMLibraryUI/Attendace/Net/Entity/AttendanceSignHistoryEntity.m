//
//  AttendanceSignHistoryEntity.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/26.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceSignHistoryEntity.h"
#import "MJExtension.h"
#import "SystemConfig.h"
#import "AttendanceConfig.h"
#import "FMUtilsPackages.h"


@implementation AttendanceSignHistoryRequestParam
- (NSString *)getUrl {
    NSString * url = [self wrapUrl:[NSString stringWithFormat:@"%@%@",[SystemConfig getServerAddress],ATTENDANCE_SIGNIN_HISTORY_URL]];
    return url;
}
@end

@implementation AttendanceSignHistoryDetailEntity
@end

@implementation AttendanceSignHistoryResponse
+ (NSDictionary *) mj_objectClassInArray {
    return @{@"data" : @"AttendanceSignHistoryDetailEntity"
             };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [NSMutableArray new];
    }
    return self;
}
@end
