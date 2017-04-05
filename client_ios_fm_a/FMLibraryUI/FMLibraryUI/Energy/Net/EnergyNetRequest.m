//
//  EnergyStarNetRequest.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/26.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "EnergyNetRequest.h"
#import "SystemConfig.h"
#import "FMUtils.h"

static EnergyNetRequest * instance = nil;

@implementation EnergyNetRequest

+ (instancetype)getInstance {
    if (!instance) {
        instance = [[EnergyNetRequest alloc] init];
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
