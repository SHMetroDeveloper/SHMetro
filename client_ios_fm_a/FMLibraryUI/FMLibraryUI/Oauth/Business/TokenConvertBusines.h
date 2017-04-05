//
//  TokenConvert.h
//  FMLibraryUI
//
//  Created by 林江锋 on 2017/3/27.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseBusiness.h"
#import "BaseRequest.h"

typedef NS_ENUM(NSInteger, BUSINESS_TOKEN_CONVERT) {
    BUSINESS_TOKEN_TYPE_CONVERT,
};

@interface TokenConvertBusines : NSObject

//获取工单业务的实例对象
+ (instancetype) getInstance;

//获取新的Token
- (void)tokenConvert:(NSString *)primaryToken success:(business_success_block)success fail:(business_failure_block)fail;

@end
