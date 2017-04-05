//
//  ContractNetRequest.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NetRequest.h"

@interface ContractNetRequest : NetRequest

+ (instancetype) getInstance;


- (void) request: (BaseRequest*) request
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

@end
