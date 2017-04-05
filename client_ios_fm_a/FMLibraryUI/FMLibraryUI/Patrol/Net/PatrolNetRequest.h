//
//  PatrolNetRequest.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/15.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequest.h"
#import "BaseRequest.h"

@interface PatrolNetRequest : NetRequest

+ (instancetype) getInstance;

- (void) request:(BaseRequest*) request
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;



@end