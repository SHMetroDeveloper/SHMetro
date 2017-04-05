//
//  TokenConvertRequest.m
//  FMLibraryUI
//
//  Created by 林江锋 on 2017/3/27.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "TokenConvertRequest.h"
#import "SystemConfig.h"
#import "FMUtils.h"

static TokenConvertRequest * instance = nil;

@implementation TokenConvertRequest

+ (instancetype) getInstance {
    if(!instance) {
        instance = [[TokenConvertRequest alloc] init];
    }
    return instance;
}

//发送请求
- (void) request: (BaseRequest*) request
    primaryToken: (NSString *) primaryToken
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    NSString * accessToken = primaryToken;
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    
    [self addRequest:request success:success failure:failure accessToken:accessToken deviceId:deviceId projectId:projectId];
}

@end
