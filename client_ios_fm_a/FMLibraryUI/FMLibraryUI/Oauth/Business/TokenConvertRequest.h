//
//  TokenConvertRequest.h
//  FMLibraryUI
//
//  Created by 林江锋 on 2017/3/27.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequest.h"
#import <UIKit/UIKit.h>

@interface TokenConvertRequest : NetRequest

+ (instancetype) getInstance;


- (void) request: (BaseRequest*) request
         primaryToken: (NSString *) primaryToken
         success: (void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

@end
