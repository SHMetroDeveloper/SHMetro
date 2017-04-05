//
//  AttendanceNetRequest.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/21.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceNetRequest.h"
#import "SystemConfig.h"
#import "FMUtilsPackages.h"

static AttendanceNetRequest *instance = nil;

@implementation AttendanceNetRequest

+ (instancetype) getInstance {
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[AttendanceNetRequest alloc] init];
        });
    }
    return instance;
}

- (void) request: (BaseRequest*) request
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    
    [self addRequest:request success:success failure:failure accessToken:accessToken deviceId:deviceId projectId:projectId];
}

@end
