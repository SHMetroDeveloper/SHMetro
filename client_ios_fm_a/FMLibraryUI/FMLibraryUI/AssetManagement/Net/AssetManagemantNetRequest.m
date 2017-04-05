//
//  AssetManagemantNetRequest.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/2.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "AssetManagemantNetRequest.h"
#import "SystemConfig.h"
#import "FMUtils.h"

static AssetManagemantNetRequest * instance = nil;

@implementation AssetManagemantNetRequest

+ (instancetype) getInstance {
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[AssetManagemantNetRequest alloc] init];
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
