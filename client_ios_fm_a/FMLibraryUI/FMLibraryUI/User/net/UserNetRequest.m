//
//  UserNetRequest.m
//  hello
//
//  Created by 杨帆 on 15/3/31.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "UserNetRequest.h"
 
#import "FMUtils.h"
#import "SystemConfig.h"

static UserNetRequest * instance = nil;

@implementation UserNetRequest


+ (instancetype) getInstance {
    
    if(!instance) {
        instance = [[UserNetRequest alloc] init];
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
