//
//  UserNetRequest.h
//  hello
//
//  Created by 杨帆 on 15/3/31.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequest.h"
#import "BaseRequest.h"

@interface UserNetRequest : NetRequest

+ (instancetype) getInstance;

- (void) request: (BaseRequest*) request
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

@end
