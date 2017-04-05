//
//  NotificationSummaryEntity.m
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/19.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "NotificationSummaryEntity.h"
#import "SystemConfig.h"

const NSInteger DEFAULT_NOTIFICATION_COUNT = 2;

@implementation NotificationSummaryRequestParam

- (instancetype) init {
    self = [super init];
    if(self) {
        _type = [[NSMutableArray alloc] init];
        _count = DEFAULT_NOTIFICATION_COUNT;
    }
    return self;
}

- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], NOTIFICATION_REQUEST_SUMMARY_URL];
    return res;
}

@end

@implementation NotificationSummaryRequestResponse
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"NotificationEntity"
             };
}
@end
