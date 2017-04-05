//
//  MessageRequest.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 2017/2/10.
//  Copyright © 2017年 facilityone. All rights reserved.
//

#import "MessageRequest.h"
#import "SystemConfig.h"
#import "FMUtilsPackages.h"

static MessageRequest *instance = nil;

@implementation MessageRequest

+ (instancetype) getInstance {
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[MessageRequest alloc] init];
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
