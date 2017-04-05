//
//  WorkOrderNetRequest.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "WorkOrderNetRequest.h"
#import "SystemConfig.h"
#import "FMUtils.h"

static WorkOrderNetRequest * instance = nil;

@implementation WorkOrderNetRequest

+ (instancetype) getInstance {
    if(!instance) {
        instance = [[WorkOrderNetRequest alloc] init];
    }
    return instance;
}


//发送请求
- (void) request:(BaseRequest*) request
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    
    [self addRequest:request success:success failure:failure accessToken:accessToken deviceId:deviceId projectId:projectId];
}

@end