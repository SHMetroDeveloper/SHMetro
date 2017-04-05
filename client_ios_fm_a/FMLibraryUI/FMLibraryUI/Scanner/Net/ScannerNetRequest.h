//
//  ScannerNetRequest.h
//  FMLibraryUI
//
//  Created by Jonzzs on 2017/3/9.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequest.h"

@interface ScannerNetRequest : NetRequest

+ (instancetype)getInstance;


/**
 从服务器请求数据
 
 @param request 请求参数
 */
- (void) request:(BaseRequest*) request
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

@end
