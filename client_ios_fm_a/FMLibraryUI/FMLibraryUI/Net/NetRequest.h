//
//  NetRequest.h
//  hello
//
//  Created by 杨帆 on 15/3/25.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "BaseRequest.h"
#import "JsonRequest.h"


typedef void (^NetRequestSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^NetRequestFailBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface NetErrorHandler : NSObject

- (instancetype) init;

//设置错误处理回调 block
- (void) setErrorCallbackBlock:(NetRequestFailBlock) failure;

//用于刷新token之后重新请求网络数据
- (void) setRequest:(JsonRequest *) request;

@end

@interface NetRequest : NSObject
- (instancetype) init;
- (void) initNetRequest;
- (void) addRequest:(BaseRequest *) request
            success: (NetRequestSuccessBlock)success
            failure: (NetRequestFailBlock)failure
        accessToken: (NSString *)token
           deviceId: (NSString *)devId
          projectId: (NSNumber *) projectId;

- (void) request: (BaseRequest *) request
         success: (NetRequestSuccessBlock) success
         failure: (NetRequestFailBlock) failure
     accessToken: (NSString *)token
        deviceId: (NSString *)devId
       projectId:(NSNumber *) projectId;

- (void) cacelAll;

@end
