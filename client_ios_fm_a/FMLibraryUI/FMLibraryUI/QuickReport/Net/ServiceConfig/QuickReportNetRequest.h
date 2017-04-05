//
//  QuickReportNetRequest.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/13.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequest.h"

@interface QuickReportNetRequest : NetRequest

+ (instancetype) getInstance;


- (void) request: (BaseRequest*) request
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

@end
