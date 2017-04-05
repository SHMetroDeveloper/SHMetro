//
//  ServiceCenterNetRequest.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/12/21.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequest.h"


@interface ServiceCenterNetRequest : NetRequest

+ (instancetype) getInstance;

- (void) request: (BaseRequest*) request
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

@end
