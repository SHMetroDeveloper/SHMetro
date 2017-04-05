//
//  ContractNetRequest.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ContractNetRequest.h"
#import "SystemConfig.h"
#import "FMUtils.h"

static ContractNetRequest * instance = nil;

@implementation ContractNetRequest

+ (instancetype) getInstance {
    if(!instance) {
        instance = [[ContractNetRequest alloc] init];
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
