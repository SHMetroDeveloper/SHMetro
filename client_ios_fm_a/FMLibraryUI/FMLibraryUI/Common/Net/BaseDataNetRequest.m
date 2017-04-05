//
//  BaseDataNetRequest.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/2.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseDataNetRequest.h"
#import "SystemConfig.h"
#import "FMUtils.h"

static BaseDataNetRequest * instance = nil;

@implementation BaseDataNetRequest

+ (instancetype) getInstance {
    if(!instance) {
        instance = [[BaseDataNetRequest alloc] init];
    }
    return instance;
}


- (void) request:(BaseRequest*) request
           token:(NSString *) accessToken
        deviceId:(NSString*) deviceId
       projectId:(NSNumber *) projectId
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    [self addRequest:request success:success failure:failure accessToken:accessToken deviceId:deviceId projectId:projectId];
}

//请求获取基础信息
- (void) request:(BaseRequest*) request
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    
    [self addRequest:request success:success failure:failure accessToken:accessToken deviceId:deviceId projectId:projectId];
}
@end

