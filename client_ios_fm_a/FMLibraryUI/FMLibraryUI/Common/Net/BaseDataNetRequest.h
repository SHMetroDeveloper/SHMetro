//
//  BaseDataNetRequest.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/2.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequest.h"

@interface BaseDataNetRequest : NetRequest

+ (instancetype) getInstance;

//请求获取基础信息
- (void) request:(BaseRequest*) request
           token:(NSString*) accessToken
        deviceId:(NSString*) deviceId
       projectId:(NSNumber *) projectId
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

//请求获取基础信息
- (void) request:(BaseRequest*) request
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;


@end
