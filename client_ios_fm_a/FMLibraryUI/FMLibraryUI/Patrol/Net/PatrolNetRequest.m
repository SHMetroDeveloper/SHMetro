//
//  PatrolNetRequest.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/15.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolNetRequest.h"
#import "SystemConfig.h"
#import "FMUtils.h"

static PatrolNetRequest * instance = nil;

@implementation PatrolNetRequest

+ (instancetype) getInstance {
    if(!instance) {
        instance = [[PatrolNetRequest alloc] init];
    }
    return instance;
}

//获取未处理巡检任务数
- (void) request:(BaseRequest*) request
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    [self addRequest:request success:success failure:failure accessToken:accessToken deviceId:deviceId projectId:projectId];
}

@end
