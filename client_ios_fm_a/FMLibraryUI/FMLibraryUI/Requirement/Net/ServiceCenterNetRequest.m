//
//  ServiceCenterNetRequest.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/12/21.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "ServiceCenterNetRequest.h"
#import "SystemConfig.h"
#import "FMUtils.h"

static ServiceCenterNetRequest * instance = nil;

@implementation ServiceCenterNetRequest

+ (instancetype) getInstance {
    if(!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[ServiceCenterNetRequest alloc] init];
        });
    }
    return instance;
}

//发送请求
- (void) request: (BaseRequest*) request
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    
    [self addRequest:request success:success failure:failure accessToken:accessToken deviceId:deviceId projectId:projectId];
}

@end
