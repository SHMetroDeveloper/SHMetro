//
//  ReportNetRequest.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequest.h"

@interface ReportNetRequest : NetRequest

+ (instancetype) getInstance;

//请求上传报障数据
- (void) request:(BaseRequest*) request
           token:(NSString *) accessToken
        deviceId:(NSString*) deviceId
       projectId:(NSNumber *) projectId
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

@end
