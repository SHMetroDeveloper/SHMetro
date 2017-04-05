//
//  PlannedMaintenanceNetRequest.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/27.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "NetRequest.h"

@interface PlannedMaintenanceNetRequest : NetRequest

+ (instancetype) getInstance;

- (void) request: (BaseRequest*) request
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

@end
