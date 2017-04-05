//
//  AttendanceNetRequest.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/21.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequest.h"

@interface AttendanceNetRequest : NetRequest

+ (instancetype) getInstance;

- (void) request: (BaseRequest*) request
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

@end
