//
//  PowerBusiness.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/26/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "PowerBusiness.h"
#import "PowerServerConfig.h"
#import "MJExtension.h"
#import "NetRequest.h"
#import "SystemConfig.h"
#import "FMUtils.h"
#import "PowerEntity.h"

PowerBusiness * powerBusinessInstance;

@interface PowerBusiness ()

@property (readwrite, nonatomic, strong) NetRequest * netRequest;

@end

@implementation PowerBusiness

+ (instancetype) getInstance {
    if(!powerBusinessInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            powerBusinessInstance = [[PowerBusiness alloc] init];
        });
    }
    return powerBusinessInstance;
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _netRequest = [[NetRequest alloc] init];
    }
    return self;
}

//获取巡检任务
- (void) requestPermissionListSuccess:(business_success_block) success fail:(business_failure_block) fail {
    
    if(_netRequest) {
        NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
        NSString * deviceId = [FMUtils getDeviceIdString];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        PowerRequestParam * param = [[PowerRequestParam alloc] init];
        [_netRequest addRequest:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            PowerRequestResponse * response = [PowerRequestResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_POWER_GET_PERMISSION, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_POWER_GET_PERMISSION, error);
            }
        } accessToken:accessToken deviceId:deviceId projectId:projectId];
    }
}

@end
