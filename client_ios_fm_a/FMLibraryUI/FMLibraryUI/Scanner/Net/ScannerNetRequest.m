//
//  ScannerNetRequest.m
//  FMLibraryUI
//
//  Created by Jonzzs on 2017/3/9.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "ScannerNetRequest.h"
#import "FMUtils.h"
#import "SystemConfig.h"

static ScannerNetRequest * instance = nil;

@implementation ScannerNetRequest

+ (instancetype)getInstance {
    
    if(!instance) {
        
        instance = [[ScannerNetRequest alloc] init];
    }
    return instance;
}


/**
 从服务器请求数据

 @param request 请求参数
 */
- (void)request:(BaseRequest*)request
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    [self addRequest:request success:success failure:failure accessToken:accessToken deviceId:deviceId projectId:projectId];
}

@end
