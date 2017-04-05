//
//  QuickReportNetRequest.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/13.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "QuickReportNetRequest.h"
#import "SystemConfig.h"
#import "FMUtils.h"

static QuickReportNetRequest * instance = nil;

@implementation QuickReportNetRequest

+ (instancetype) getInstance {
    if(!instance) {
        instance = [[QuickReportNetRequest alloc] init];
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
