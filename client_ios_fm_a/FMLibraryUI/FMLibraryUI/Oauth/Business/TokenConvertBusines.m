//
//  TokenConvert.m
//  FMLibraryUI
//
//  Created by 林江锋 on 2017/3/27.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "TokenConvertBusines.h"
#import "TokenConvertRequest.h"
#import "TokenConvertConfig.h"
#import "MJExtension.h"
#import "SystemConfig.h"
#import "FMUtilsPackages.h"
#import "AFNetworking.h"

TokenConvertBusines *tokenConvertBusinessInstance;

@interface TokenConvertBusines ()
@property (readwrite, nonatomic, strong) TokenConvertRequest *netRequest;
@end

@implementation TokenConvertBusines

+ (instancetype) getInstance {
    if(!tokenConvertBusinessInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            tokenConvertBusinessInstance = [[TokenConvertBusines alloc] init];
        });
    }
    return tokenConvertBusinessInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _netRequest = [TokenConvertRequest getInstance];
    }
    return self;
}

- (void)tokenConvert:(NSString *)primaryToken success:(business_success_block)success fail:(business_failure_block)fail {
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSString *mainURL = [SystemConfig getServerAddress];
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@?token=%@",mainURL ,PRIMARY_TOKEN_CONVERT_URL ,primaryToken];
    [manger POST:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(BUSINESS_TOKEN_TYPE_CONVERT,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (fail) {
            fail(BUSINESS_TOKEN_TYPE_CONVERT,error);
        }
    }];
}

@end
