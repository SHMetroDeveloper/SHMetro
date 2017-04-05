//
//  InventoryNetRequest.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "InventoryNetRequest.h"
#import "SystemConfig.h"
#import "FMUtils.h"

static InventoryNetRequest * instance = nil;

@implementation InventoryNetRequest


+ (instancetype) getInstance {
    if(!instance) {
        instance = [[InventoryNetRequest alloc] init];
    }
    return instance;
}

- (void) request:(BaseRequest*) request
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    [self addRequest:request success:success failure:failure accessToken:accessToken deviceId:deviceId projectId:projectId];
}
@end
