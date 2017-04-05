//
//  ReportNetRequest.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "ReportNetRequest.h"

static ReportNetRequest * instance = nil;

@implementation ReportNetRequest

+ (instancetype) getInstance {
    if(!instance) {
        instance = [[ReportNetRequest alloc] init];
    }
    return instance;
}

- (void) request:(BaseRequest*) request
           token:(NSString *) accessToken
        deviceId:(NSString*) deviceId
       projectId:(NSNumber *) projectId
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    [self addRequest:request success:success failure:failure accessToken:accessToken deviceId:deviceId projectId:projectId];
}

@end
