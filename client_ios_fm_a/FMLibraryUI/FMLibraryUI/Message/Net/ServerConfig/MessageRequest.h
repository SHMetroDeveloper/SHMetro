//
//  MessageRequest.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 2017/2/10.
//  Copyright © 2017年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequest.h"

@interface MessageRequest : NetRequest

+ (instancetype) getInstance;

- (void) request: (BaseRequest*) request
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

@end
